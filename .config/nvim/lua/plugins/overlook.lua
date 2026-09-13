return {
  {
    "WilliamHsieh/overlook.nvim",
    opts = {},

    keys = {
      {
        "<leader>pd",
        function()
          require("overlook.api").peek_definition()
        end,
        desc = "Overlook: Peek definition",
      },
    },
  },
}
