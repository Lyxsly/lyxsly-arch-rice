local function preload_quickshell_modules(client)
  local root = client.config.root_dir
  if not root then
    return
  end

  local modules = {}
  for _, path in ipairs(vim.fn.glob("/usr/lib/qt6/qml/Quickshell/**/qmldir", false, true)) do
    local ok, lines = pcall(vim.fn.readfile, path)
    if ok then
      for _, line in ipairs(lines) do
        local module = line:match("^%s*module%s+(%S+)")
        if module then
          if not module:find("%._") then
            modules[module] = true
          end
          break
        end
      end
    else
      vim.notify("qmlls: failed to read " .. path, vim.log.levels.WARN)
    end
  end
  local names = vim.tbl_keys(modules)
  if #names == 0 then
    return
  end
  table.sort(names)

  local lines = { "import QtQml" }
  for i, name in ipairs(names) do
    lines[#lines + 1] = ("import %s as Preload%d"):format(name, i)
  end
  lines[#lines + 1] = "QtObject {}"

  -- qmlls only suggests modules it has loaded. Open a virtual document to load them.
  local uri = vim.uri_from_fname(root .. "/.__qmlls_preload_" .. client.id .. ".qml")
  local diagnostics = client.handlers["textDocument/publishDiagnostics"]
    or vim.lsp.handlers["textDocument/publishDiagnostics"]
  client.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
    if result and result.uri == uri then
      return
    end
    return diagnostics(err, result, ctx, config)
  end

  local opened = client:notify("textDocument/didOpen", {
    textDocument = { uri = uri, languageId = "qml", version = 1, text = table.concat(lines, "\n") },
  })
  if not opened then
    vim.notify("qmlls: failed to send module preload", vim.log.levels.WARN)
    return
  end
  -- Qt 6.12 processes pending dependencies before the snapshot used by documentSymbol.
  local requested = client:request("textDocument/documentSymbol", { textDocument = { uri = uri } }, function(err)
    client:notify("textDocument/didClose", { textDocument = { uri = uri } })
    if err then
      vim.notify("qmlls: Quickshell module preload failed: " .. err.message, vim.log.levels.WARN)
    end
  end)
  if not requested then
    client:notify("textDocument/didClose", { textDocument = { uri = uri } })
    vim.notify("qmlls: failed to request module preload completion", vim.log.levels.WARN)
  end
end

return {
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        per_filetype = {
          qml = { "qml_keywords", inherit_defaults = true },
        },
        providers = {
          qml_keywords = {
            name = "QML keywords",
            module = "completion.qml_keywords",
            score_offset = 100,
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        qmlls = {
          mason = false,
          cmd = { "/usr/bin/qmlls6" },
          root_markers = { "shell.qml", ".qmlls.ini", ".git" },
          on_init = function(client)
            local provider = client.server_capabilities.semanticTokensProvider
            if provider and type(provider.full) == "table" then
              provider.full.delta = false
            end
            preload_quickshell_modules(client)
          end,
        },
      },
    },
  },
}
