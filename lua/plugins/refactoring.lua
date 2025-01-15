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

  -- LSP-based refactoring support
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      lspconfig.util.on_attach(function(client, bufnr)
        local function buf_set_keymap(...)
          vim.api.nvim_buf_set_keymap(bufnr, ...)
        end
        local opts = { noremap = true, silent = true }

        buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        buf_set_keymap("v", "<leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
      end)
    end,
  },
}
