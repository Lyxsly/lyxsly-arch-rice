return {
  {
    "folke/snacks.nvim",
    dependencies = {
      "MaximilianLloyd/ascii.nvim",
    },
    opts = function(_, opts)
      local header = require("ascii").get_random("text", "neovim")

      opts.dashboard = opts.dashboard or {}
      opts.dashboard.preset = opts.dashboard.preset or {}
      opts.dashboard.preset.header = table.concat(header, "\n")
      opts.dashboard.sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      }
    end,
  },
}
