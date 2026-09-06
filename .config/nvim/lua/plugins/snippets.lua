return {
  {
    "saghen/blink.cmp",

    dependencies = {
      {
        "r5n-labs/vscode-react-javascript-snippets",
        build = "bun install --frozen-lockfile && bun run compile",
      },
    },

    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.snippets = opts.sources.providers.snippets or {}
      opts.sources.providers.snippets.opts = opts.sources.providers.snippets.opts or {}

      local snippet_opts = opts.sources.providers.snippets.opts

      snippet_opts.search_paths = snippet_opts.search_paths
        or {
          vim.fn.stdpath("config") .. "/snippets",
        }

      table.insert(snippet_opts.search_paths, vim.fn.stdpath("data") .. "/lazy/vscode-react-javascript-snippets")
    end,
  },
}
