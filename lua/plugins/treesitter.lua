return {
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

  {
    "nvim-treesitter/nvim-treesitter",
    tag = "v0.9.1", -- Adding the tag to ensure version consistency
    opts = {
      ensure_installed = {
        "javascript",
        "typescript",
        "astro",
        "cmake",
        "cpp",
        "css",
        "fish",
        "gitignore",
        "go",
        "graphql",
        "http",
        "java",
        "json",
        "lua",
        "php",
        "rust",
        "scss",
        "sql",
        "svelte",
        "vim",
      },

      -- Enabling the query linter
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },

      -- Treesitter Playground configuration
      playground = {
        enable = true,
        disable = {},
        updatetime = 25,        -- Debounce time for highlighting nodes in the playground from source code
        persist_queries = true, -- Keep queries between Vim sessions
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- Additional configuration for MDX support
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
}
