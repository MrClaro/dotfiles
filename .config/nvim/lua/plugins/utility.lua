-- Utility plugins configuration for Neovim
return {
  --  SESSION MANAGEMENT (Persisted)
  {
    "olimorris/persisted.nvim",
    config = function()
      require("persisted").setup({
        save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
        command = "VimLeavePre",
        use_git_branch = true,
        autosave = true,
        autoload = true,
        on_autoload_no_session = function()
          vim.notify("No existing session to load.")
        end,
      })
      vim.keymap.set("n", "<leader>ss", "<cmd>SessionSave<cr>", { desc = "Save Session" })
      vim.keymap.set("n", "<leader>sl", "<cmd>SessionLoad<cr>", { desc = "Load Session" })
    end,
  },

  --  TODO COMMENTS (TODO/FIXME view)
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
      vim.keymap.set("n", "<leader>td", "<cmd>TodoTrouble<cr>", { desc = "Todo Trouble" })
      vim.keymap.set("n", "<leader>tf", "<cmd>TodoTelescope<cr>", { desc = "Todo Telescope" })
    end,
  },

  -- WAKATIME (Time tracking)
  { "wakatime/vim-wakatime", lazy = false },

  -- AUTOPAIRS
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- TYPESCRIPT TOOLS
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
}
