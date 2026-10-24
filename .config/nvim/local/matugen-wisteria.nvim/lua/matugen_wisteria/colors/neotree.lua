local M = {}

function M.setup()
	local util = require("matugen_wisteria.lib.utils")
	local p = require("matugen_wisteria.lib.palette")
	util.highlight("NeoTreeTitleBar", { bg = p.color06 })
	util.highlight("NeoTreeRootName", { fg = p.color06, bold = true })
	util.highlight("NeoTreeDirectoryName", { fg = p.color06 })
	util.highlight("NeoTreeDirectoryIcon", { fg = p.color06 })
	util.highlight("NeoTreeFileName", { fg = p.color00 })
	util.highlight("NeoTreeGitModified", { fg = p.color09 })
	util.highlight("NeoTreeGitUntracked", { fg = p.color04 })
	util.highlight("NeoTreeGitUnstaged", { fg = p.color08 })
	util.highlight("NeoTreeGitStaged", { fg = p.color07 })
	util.highlight("NeoTreeGitDeleted", { fg = p.color08 })
end

return M
