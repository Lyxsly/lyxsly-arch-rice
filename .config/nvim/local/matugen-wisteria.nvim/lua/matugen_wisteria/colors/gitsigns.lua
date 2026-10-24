local M = {}

function M.setup()
	local util = require("matugen_wisteria.lib.utils")
	local p = require("matugen_wisteria.lib.palette")
	local config = require("matugen_wisteria").config
	local transparent_bg = config.transparent and p.none or p.color03

	util.highlight("GitSignsAdd", { fg = p.color07 })
	util.highlight("GitSignsChange", { fg = p.color09 })
	util.highlight("GitSignsDelete", { fg = p.color08 })
	util.highlight("GitSignsCurrentLineBlame", { fg = p.color03 })
	util.highlight("GitSignsAddPreview", { fg = p.color01 })
	util.highlight("GitSignsDeletePreview", { fg = p.color01 })
	util.highlight("GitSignsAddInline", { fg = p.color07, bg = transparent_bg })
	util.highlight("GitSignsDeleteInline", { fg = p.color08, bg = transparent_bg })
	util.highlight("GitSignsChangeInline", { fg = p.color09, bg = transparent_bg })
	util.highlight("GitSignsDeleteVirtLn", { fg = p.color08, bg = transparent_bg })
end

return M
