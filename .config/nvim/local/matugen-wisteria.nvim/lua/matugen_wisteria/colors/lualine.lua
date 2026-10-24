return function()
	local p = require("matugen_wisteria.lib.palette")
	local config = require("matugen_wisteria").config
	local transparent_bg = config.transparent and p.none or p.color03
	return {
		normal = { a = { fg = p.color03, bg = p.color06, gui = "bold" }, b = { fg = p.color06, bg = p.color03 }, c = { fg = p.color00, bg = transparent_bg } },
		insert = { a = { fg = p.color03, bg = p.color07, gui = "bold" }, b = { fg = p.color07, bg = p.color03 } },
		visual = { a = { fg = p.color03, bg = p.color04, gui = "bold" }, b = { fg = p.color04, bg = p.color03 } },
		replace = { a = { fg = p.color03, bg = p.color08, gui = "bold" }, b = { fg = p.color08, bg = p.color03 } },
		command = { a = { fg = p.color03, bg = p.color09, gui = "bold" }, b = { fg = p.color09, bg = p.color03 } },
		inactive = { a = { fg = p.color06, bg = transparent_bg }, b = { fg = p.color03, bg = transparent_bg, gui = "bold" }, c = { fg = p.color03, bg = transparent_bg } },
		terminal = { a = { fg = p.color03, bg = p.color07, gui = "bold" }, b = { fg = p.color07, bg = p.color03 } },
	}
end
