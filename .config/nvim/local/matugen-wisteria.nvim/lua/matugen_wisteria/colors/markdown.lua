local M = {}

function M.setup()
	local util = require("matugen_wisteria.lib.utils")
	local p = require("matugen_wisteria.lib.palette")
	util.highlight("RenderMarkdownCode", { bg = p.color03 })
	util.highlight("RenderMarkdownCodeInline", { bg = p.color01 })
	util.highlight("RenderMarkdownBullet", { fg = p.color05 })
	util.highlight("RenderMarkdownTableHead", { fg = p.color06 })
	util.highlight("RenderMarkdownTableRow", { fg = p.color00 })
	util.highlight("RenderMarkdownSuccess", { fg = p.color04 })
	util.highlight("RenderMarkdownInfo", { fg = p.color12 })
	util.highlight("RenderMarkdownHint", { fg = p.color05 })
	util.highlight("RenderMarkdownWarn", { fg = p.color10 })
	util.highlight("RenderMarkdownError", { fg = p.color11 })
	local headings = { p.color08, p.color04, p.color09, p.color07, p.color00, p.color00 }
	for level, color in ipairs(headings) do
		util.highlight("RenderMarkdownH" .. level, { fg = color })
		util.highlight("RenderMarkdownH" .. level .. "Bg", { fg = color })
	end
end

return M
