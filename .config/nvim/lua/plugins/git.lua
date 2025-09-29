return {
  -- 1. LAZYGIT (TUI)
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      name = "🔧 Git",
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "📘 Open LazyGit" },
      { "<leader>lf", "<cmd>LazyGitFilter<cr>", desc = "🔍 Filter Git changes" },
      { "<leader>lc", "<cmd>LazyGitConfig<cr>", desc = "⚙️ Open LazyGit Config" },
    },
  },

  -- 2. ADVANCED GIT SEARCH (depende de Fugitive/Rhubarb)
  {
    "aaronhallaert/advanced-git-search.nvim",
    dependencies = {
      "tpope/vim-fugitive",
      "tpope/vim-rhubarb",
    },
  },

  -- 3. GITSIGNS (Indicadores visuais de alteração)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        on_attach = function(buffer)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
          end
          map("n", "<leader>gb", gs.blame_line, "Git Blame")
          map("n", "<leader>gd", gs.diffthis, "Git Diff")
          map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
        end,
      })
    end,
  },
}
