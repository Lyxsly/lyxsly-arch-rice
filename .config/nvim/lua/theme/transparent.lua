local M = {}

local groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "StatusLine",
  "StatusLineNC",
  "GitSignsAddInline",
  "GitSignsDeleteInline",
  "GitSignsChangeInline",
  "GitSignsDeleteVirtLn",
}

local lualine_groups = {
  "lualine_c_normal",
  "lualine_a_inactive",
  "lualine_b_inactive",
  "lualine_c_inactive",
}

local function clear_bg(group)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if not ok then
    return
  end

  hl.bg = nil
  hl.ctermbg = nil
  vim.api.nvim_set_hl(0, group, hl)
end

function M.apply()
  for _, group in ipairs(groups) do
    clear_bg(group)
  end

  for _, group in ipairs(lualine_groups) do
    clear_bg(group)
  end
end

return M
