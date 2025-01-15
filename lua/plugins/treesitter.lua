return {
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

  {
    "nvim-treesitter/nvim-treesitter",
    tag = "v0.9.1",
    opts = {
      ensure_installed = {
        "typescript",
        "astro",
        "cmake",
        "cpp",
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

      ignore_install = { "html", "javascript", "css" },

      playground = {
        enable = false,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
}
