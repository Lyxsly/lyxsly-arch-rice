local source = {}

local modifiers = { required = true, readonly = true, default = true }
local declarations = { "property", "required", "readonly", "default", "signal", "function", "component", "enum" }

local function unclosed_braces(node)
  local kind = node:type()
  if kind == "{" then
    return 1
  elseif kind == "}" then
    return -1
  elseif kind == "comment" or kind:find("string") then
    return 0
  end
  local count = 0
  for child in node:iter_children() do
    count = count + unclosed_braces(child)
  end
  return count
end

local function keywords_at(ctx)
  if vim.bo[ctx.bufnr].filetype ~= "qml" then
    return {}
  end

  local row, col = ctx.cursor[1] - 1, ctx.cursor[2]
  local line = vim.api.nvim_buf_get_lines(ctx.bufnr, row, row + 1, false)[1] or ""
  local before = line:sub(1, col)
  -- Only complete the start of a declaration, never a binding or member access.
  local prefix = before:gsub("[%w_]*$", "")
  local used = {}
  for word in prefix:gmatch("%S+") do
    if not modifiers[word] or used[word] then
      return {}
    end
    used[word] = true
  end

  local ok, parser = pcall(vim.treesitter.get_parser, ctx.bufnr, "qmljs")
  if not ok then
    return {}
  end
  local trees = parser:parse()
  local root = trees[1]:root()
  -- An unfinished root object can become a single ERROR node. Repair only the
  -- parser input, leaving the actual buffer untouched, to recover its context.
  if root:type() == "ERROR" then
    local missing = unclosed_braces(root)
    if missing > 0 then
      local text = table.concat(vim.api.nvim_buf_get_lines(ctx.bufnr, 0, -1, false), "\n")
      local repaired = vim.treesitter.get_string_parser(text .. string.rep("\n}", missing), "qmljs")
      root = repaired:parse()[1]:root()
    else
      return {}
    end
  end
  local node = root:named_descendant_for_range(row, math.max(col - 1, 0), row, math.max(col - 1, 0))
  while node do
    local kind = node:type()
    if kind:find("string") or kind == "comment" or kind == "statement_block" or kind == "array" then
      return {}
    end
    if kind == "ui_binding" then
      -- A partial declaration can be parsed as a binding; its value is still JS.
      local value = node:field("value")[1]
      if value and vim.treesitter.is_in_node_range(value, row, math.max(col - 1, 0)) then
        return {}
      end
    end
    if kind == "ui_object_initializer" then
      local parent = node:parent()
      local name = parent and parent:field("type_name")[1]
      -- Grouped properties such as `anchors {}` do not accept declarations.
      if name and not vim.treesitter.get_node_text(name, ctx.bufnr):match("^[%u_]") then
        return {}
      end
      if next(used) then
        return { "property" }
      end
      return declarations
    end
    node = node:parent()
  end

  if next(used) then
    return {}
  end
  for child in root:iter_children() do
    if child:type() == "ui_object_definition" and child:start() <= row then
      return {}
    end
  end
  return { "import", "pragma" }
end

function source.new()
  return setmetatable({}, { __index = source })
end

function source:get_completions(ctx, callback)
  local items = {}
  for _, keyword in ipairs(keywords_at(ctx)) do
    items[#items + 1] = {
      label = keyword,
      kind = vim.lsp.protocol.CompletionItemKind.Keyword,
      insertText = keyword,
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
    }
  end
  callback({ items = items, is_incomplete_forward = true, is_incomplete_backward = true })
end

return source
