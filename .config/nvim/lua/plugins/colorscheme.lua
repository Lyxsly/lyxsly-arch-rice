-- ~/.config/nvim/lua/plugins/colorscheme.lua

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "wisteria",
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "wisteria",
      },
    },
  },

  {
    "masisz/wisteria.nvim",
    name = "wisteria",
    commit = "937f9ff0435e30b9e5798b4b9e2b5ed3d83ee8e5",
    opts = {
      priority = 1000,
      transparent = true,
    },
  },

  {
    "RRethy/base16-nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
