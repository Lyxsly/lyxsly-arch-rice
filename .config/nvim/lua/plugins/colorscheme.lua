-- ~/.config/nvim/lua/plugins/colorscheme.lua
-- ~/.config/nvim/lua/plugins/colorscheme.lua

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "wisteria",
    },
  },

  {
    "masisz/wisteria.nvim",
    name = "wisteria",
    -- commit = "937f9ff0435e30b9e5798b4b9e2b5ed3d83ee8e5",
    opts = {
      transparent = true,
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
}
-- return {
--   {
--     "folke/tokyonight.nvim",
--     opts = {
--       transparent = true,
--       styles = {
--         sidebars = "transparent",
--         floats = "transparent",
--       },
--     },
--   },
-- }
