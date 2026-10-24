local M = {}

function M.setup()
	local util = require("matugen_wisteria.lib.utils")
	local p = require("matugen_wisteria.lib.palette")
	local config = require("matugen_wisteria").config
	local transparent_bg = config.transparent and p.none or p.color03

	util.highlight("Normal", { bg = transparent_bg })
	util.highlight("NormalNC", { bg = transparent_bg })
	util.highlight("NormalFloat", { bg = transparent_bg })
	util.highlight("Comment", { fg = p.color01, italic = true })
	util.highlight("String", { fg = p.color07 })
	util.highlight("Function", { fg = p.color06 })
	util.highlight("Statement", { fg = p.color04 })
	util.highlight("Special", { fg = p.color08 })
	util.highlight("Number", { fg = p.color09 })
	util.highlight("Keyword", { fg = p.color04 })
	util.highlight("Constant", { fg = p.color09 })
	util.highlight("Type", { fg = p.color04 })
	util.highlight("Operator", { fg = p.color05 })
	util.highlight("Identifier", { fg = p.color00 })
	util.highlight("Delimiter", { fg = p.color00 })
	util.highlight("MatchParen", { fg = p.color08, bold = true })
	util.highlight("LineNr", { fg = p.color02 })
	util.highlight("CursorLineNr", { fg = p.color00, bold = true })
	util.highlight("StatusLine", { bg = transparent_bg })
	util.highlight("StatusLineNC", { bg = transparent_bg })
	util.highlight("DiagnosticError", { fg = p.color11 })
	util.highlight("DiagnosticWarn", { fg = p.color10 })
	util.highlight("DiagnosticInfo", { fg = p.color12 })
	util.highlight("DiagnosticHint", { fg = p.color05 })
	util.highlight("Search", { bg = p.color18, fg = p.color03 })
	util.highlight("IncSearch", { bg = p.color24, fg = p.color03 })
	util.highlight("CursorLine", { bg = p.color17 })
	util.highlight("Visual", { bg = p.color13 })
end

return M
