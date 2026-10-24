local M = {}

function M.setup()
	local util = require("matugen_wisteria.lib.utils")
	local p = require("matugen_wisteria.lib.palette")
	util.highlight("SnacksDashboardHeader", { fg = p.color06 })
	util.highlight("SnacksDashboardFooter", { fg = p.color09 })
	util.highlight("SnacksDashboardFile", { fg = p.color04 })
	util.highlight("SnacksDashboardDesc", { fg = p.color04 })
	util.highlight("SnacksDashboardIcon", { fg = p.color04, bold = true })
	util.highlight("SnacksDashboardKey", { fg = p.color08 })
	util.highlight("SnacksDashboardNormal", { link = "Normal" })
	util.highlight("SnacksDashboardTitle", { link = "Title" })
	util.highlight("SnacksDashboardSpecial", { link = "Special" })
	util.highlight("SnacksDashboardTerminal", { link = "SnacksDashboardNormal" })
	util.highlight("SnacksDashboardDir", { fg = p.color06 })
	util.highlight("SnacksPickerDirectory", { fg = p.color06 })
	util.highlight("SnacksPickerFile", { fg = p.color00 })
	util.highlight("SnacksPickerGitStatusUntracked", { fg = p.color04 })
end

return M
