-- Plugins que adicionam funcionalidades específicas e ferramentas de edição.

return {
  -- 1. FLASH.NVIM (Navegação Rápida)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    -- Mapeamentos de tecla específicos (zK, R, etc.)
    keys = {
      {
        "zk",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash Jump",
      },
      {
        "Zk",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  -- 2. TYPST PREVIEW (Visualização de documentos Typst)
  {
    "chomosuke/typst-preview.nvim",
    lazy = false,
    version = "1.*",
    opts = {
      invert_colors = "always",
    },
    build = function()
      require("typst-preview").update()
    end,
  },

  -- 3. TYPST SYNTAX (Suporte à sintaxe Typst)
  {
    "kaarmu/typst.vim",
    ft = "typst",
    enabled = not vim.g.vscode,
    lazy = false,
  },

  -- 4. NVIM-TS-AUTOTAG (Auto-fechamento e renomeação de tags HTML/XML)
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
        per_filetype = {
          ["html"] = { enable_close = false },
        },
      })
    end,
  },

  -- 6. MARKDOWN-PREVIEW.NVIM (Pré-visualização de Markdown)
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- 7. NVIM-SURROUND (Manipulação de Text Objects de Surround)
  {
    "kylechui/nvim-surround",
    version = "^3.0.0",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          normal = "gs",
          visual = "gS",
          delete = "ds",
          change = "cs",
        },
      })
    end,
  },
}
