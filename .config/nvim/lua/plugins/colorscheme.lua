-- ~/.config/nvim/lua/plugins/colorscheme.lua

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "matugen-wisteria",
      -- colorscheme = function()
      --   vim.cmd.colorscheme("tokyonight")
      --   require("theme.transparent").apply()
      -- end,
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "matugen-wisteria",
      },
    },
  },

  -- {
  --   "masisz/wisteria.nvim",
  --   name = "wisteria",
  --   commit = "937f9ff0435e30b9e5798b4b9e2b5ed3d83ee8e5",
  --   opts = {
  --     priority = 1000,
  --     transparent = true,
  --   },
  -- },
  {
    dir = vim.fn.stdpath("data") .. "/local/matugen-wisteria.nvim",
    name = "matugen-wisteria",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },
  {
    "RRethy/base16-nvim",
    lazy = false,
    priority = 1000,
  },

  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     transparent = false,
  --     -- styles = {
  --     --   sidebars = "transparent",
  --     --   floats = "transparent",
  --     -- },
  --   },
  -- },
}
