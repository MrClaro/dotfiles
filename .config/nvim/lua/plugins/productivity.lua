-- Plugins focados em produtividade, refatoração, e navegação de símbolos.
return {
  -- 1. NEOGEN (Geração de Docstrings/Comentários)
  {
    "danymat/neogen",
    keys = {
      {
        "<leader>cn",
        function()
          require("neogen").generate({})
        end,
        desc = "Generate Docstring (Neogen)",
      },
    },
    opts = { snippet_engine = "luasnip" },
  },

  -- 3. MINI.BRACKETED (Navegação com Colchetes)
  {
    "nvim-mini/mini.bracketed",
    event = "BufReadPost",
    config = function()
      require("mini.bracketed").setup({
        file = { suffix = "" },
        window = { suffix = "" },
        quickfix = { suffix = "" },
        yank = { suffix = "" },
        treesitter = { suffix = "n" },
      })
    end,
  },

  -- 4. DIAL.NVIM (Incrementar/Decrementar Inteligente)
  {
    "monaqa/dial.nvim",
    keys = {
      {
        "<C-a>",
        function()
          return require("dial.map").inc_normal()
        end,
        expr = true,
        desc = "Increment Value",
      },
      {
        "<C-x>",
        function()
          return require("dial.map").dec_normal()
        end,
        expr = true,
        desc = "Decrement Value",
      },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { "let", "const" } }),
        },
      })
    end,
  },

  -- 5. SYMBOLS-OUTLINE (Navegação de Símbolos)
  {
    "simrat39/symbols-outline.nvim",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    cmd = "SymbolsOutline",
    opts = { position = "right" },
  },

  -- 6. HARDTIME.NVIM (Melhoria de Hábitos)
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      java = {
        enabled = true,
        show_dependencies = true,
        show_implementations = true,
      },
    },
  },
}
