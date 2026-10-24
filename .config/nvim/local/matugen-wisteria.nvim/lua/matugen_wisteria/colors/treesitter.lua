local M = {}

function M.setup()
	local util = require("matugen_wisteria.lib.utils")
	local p = require("matugen_wisteria.lib.palette")
	local groups = {
		["@field"] = p.color05, ["@property"] = p.color05, ["@method"] = p.color06,
		["@type"] = p.color04, ["@constructor"] = p.color09, ["@class"] = p.color04,
		["@variable"] = p.color00, ["@variable.builtin"] = p.color08,
		["@variable.parameter"] = p.color09, ["@variable.parameter.builtin"] = p.color08,
		["@variable.member"] = p.color05, ["@punctuation.bracket"] = p.color01,
		["@keyword"] = p.color04, ["@keyword.import"] = p.color04,
		["@keyword.coroutine"] = p.color04, ["@keyword.function"] = p.color06,
	}
	for group, color in pairs(groups) do util.highlight(group, { fg = color }) end

	local todo = { fg = p.color00, bg = p.color06 }
	local note = { fg = p.color00, bg = p.color12 }
	local warning = { fg = p.color03, bg = p.color10 }
	local error_style = { fg = p.color00, bg = p.color11 }
	util.highlight("@comment.todo", todo)
	util.highlight("@comment.note", note)
	util.highlight("@comment.warning", warning)
	util.highlight("@comment.error", error_style)
	util.highlight("@text.todo", todo)
	util.highlight("@text.note", note)
	util.highlight("@text.warning", warning)
	util.highlight("@text.danger", error_style)

	local headings = { p.color08, p.color04, p.color09, p.color07, p.color00, p.color00 }
	for level, color in ipairs(headings) do
		util.highlight("@markup.heading." .. level .. ".markdown", { fg = color, bold = true })
	end
	util.highlight("@markup", { fg = p.color00 })
	util.highlight("@markup.list", { fg = p.color00 })
	util.highlight("@markup.list.checked", { fg = p.color07 })
	util.highlight("@markup.list.unchecked", { fg = p.color07 })
	util.highlight("@markup.link", { fg = p.color04 })
	util.highlight("@type.builtin.c", { fg = p.color04 })
	util.highlight("@type.builtin.cpp", { fg = p.color04 })
	util.highlight("@property.cpp", { fg = p.color06 })
end

return M
