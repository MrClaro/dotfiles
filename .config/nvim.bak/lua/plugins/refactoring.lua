return {
  -- Incremental rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>rn",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        desc = "Incremental rename",
        mode = "n",
        noremap = true,
        expr = true,
      },
    },
    config = true,
  },

  -- Refactoring tool
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor({
            show_success_message = true,
          })
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    opts = {},
  },

  -- Split and Join
  {
    "AndrewRadev/splitjoin.vim",
    keys = {
      { "gS", "<cmd>SplitjoinSplit<cr>", desc = "Split the line" },
      { "gJ", "<cmd>SplitjoinJoin<cr>", desc = "Join the line" },
    },
  },

  -- Structural Editing (Tree-sitter powered)
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-refactor",
        config = function()
          require("nvim-treesitter.configs").setup({
            refactor = {
              highlight_definitions = {
                enable = true,
              },
              highlight_current_scope = {
                enable = true,
              },
              smart_rename = {
                enable = true,
                keymaps = {
                  smart_rename = "grr",
                },
              },
              navigation = {
                enable = true,
                keymaps = {
                  goto_definition = "gnd",
                  list_definitions = "gnD",
                  list_definitions_toc = "gO",
                  goto_next_usage = "<a-*>",
                  goto_previous_usage = "<a-#>",
                },
              },
            },
          })
        end,
      },
    },
  },
}
