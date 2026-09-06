-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- ~/.config/nvim/lua/config/autocmds.lua

local function source_matugen()
  local matugen_path = vim.fn.expand("~/.config/nvim/generated.lua")

  if vim.fn.filereadable(matugen_path) == 1 then
    dofile(matugen_path)
  else
    vim.cmd("colorscheme base16-catppuccin-mocha")
    vim.notify(
      "matugen generated.lua was not found. The colorscheme will update after matugen runs.",
      vim.log.levels.WARN
    )
  end
end

local function auxiliary_function()
  source_matugen()

  vim.api.nvim_set_hl(0, "Comment", { italic = true })
end

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   callback = function()
--     vim.cmd("iabbrev <buffer> scheduled ⏳")
--     vim.cmd("iabbrev <buffer> due 📅")
--     vim.cmd("iabbrev <buffer> start 🛫")
--   end,
-- })
-- vim.api.nvim_create_autocmd("Signal", {
--   pattern = "SIGUSR1",
--   callback = auxiliary_function,
-- })

-- local function apply_transparent()
--   vim.schedule(function()
--     require("theme.transparent").apply()
--   end)
-- end
--
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   callback = apply_transparent,
-- })

-- auxiliary_function()
