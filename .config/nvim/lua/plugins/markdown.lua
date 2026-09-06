return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = {
        sign = false,
        width = "block",
      },

      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },

      checkbox = {
        enabled = true,
        unchecked = {
          icon = "󰄱 ",
        },
        checked = {
          icon = "󰱒 ",
        },
        custom = {
          progress = {
            raw = "[/]",
            rendered = "󰦖 ",
            highlight = "DiagnosticInfo",
          },

          cancelled = {
            raw = "[-]",
            rendered = "󰅖 ",
            highlight = "DiagnosticWarn",
          },
        },
      },

      bullet = {
        icons = { "●", "○", "◆", "◇" },
      },

      pipe_table = {
        preset = "round",
      },
    },
  },

  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    -- ft = "markdown",
    -- dependencies = {
    --   "nvim-lua/plenary.nvim",
    -- },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "notes",
          path = "~/documents/obsidian",
        },
      },

      templates = {
        folder = "99_System/Templates",
      },

      daily_notes = {
        enabled = true,
        folder = "20_Daily",
        date_format = "YYYY-MM-DD",
        template = "Daily.md",
      },
    },
    keys = {
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search note" },
      { "<leader>oq", "<cmd>Obsidian quickSwitch<cr>", desc = "Quick switch" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
      { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Today's note" },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>o", group = "Obsidian" },
      },
    },
  },
}
