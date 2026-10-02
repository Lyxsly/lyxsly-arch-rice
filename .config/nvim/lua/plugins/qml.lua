return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        qmlls = {
          cmd = { "qmlls6" },
          root_markers = { ".qmlls.ini", ".git" },
          on_init = function(client)
            local provider = client.server_capabilities.semanticTokensProvider
            if provider and type(provider.full) == "table" then
              provider.full.delta = false
            end
          end,
        },
      },
    },
  },
}
