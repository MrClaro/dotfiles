return {
  -- LazyGit Integration
  {
    "kdheepak/lazygit.nvim",
    lazy = false,
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
  {
    "aaronhallaert/advanced-git-search.nvim",
    dependencies = {
      "tpope/vim-fugitive",
      "tpope/vim-rhubarb",
    },
  },

  -- Better Git Integration
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

  -- Session Management
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

  -- TODO Comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
      vim.keymap.set("n", "<leader>td", "<cmd>TodoTrouble<cr>", { desc = "Todo Trouble" })
      vim.keymap.set("n", "<leader>tf", "<cmd>TodoTelescope<cr>", { desc = "Todo Telescope" })
    end,
  },

  {
    "nvzone/volt",
    { "nvzone/timerly", cmd = "TimerlyToggle" },
  },
  { "wakatime/vim-wakatime", lazy = false },
  {
    "uga-rosa/ccc.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local ccc = require("ccc")

      ccc.setup({
        default_color = "#000000",
        bar_char = "█",
        point_char = "◉",
        point_color = "",
        empty_point_bg = false,
        win_opts = {
          relative = "cursor",
          row = 1,
          col = 1,
          style = "minimal",
          border = "rounded",
        },
        auto_close = true,
        preserve = false,

        alpha_show = "auto",

        recognize = {
          input = true,
          output = true,
        },

        highlighter = {
          auto_enable = true,
          max_byte = 100 * 1024,
          update_insert = true,
          filetypes = {
            "css",
            "scss",
            "sass",
            "less",
            "stylus",
            "html",
            "javascript",
            "typescript",
            "jsx",
            "tsx",
            "vue",
            "svelte",
            "lua",
            "vim",
            "conf",
            "config",
          },
          excludes = {
            "lazy",
            "mason",
            "help",
            "neo-tree",
          },
        },
      })

      local opts = { noremap = true, silent = true }

      vim.keymap.set("n", "<leader>cp", "<cmd>CccPick<cr>", vim.tbl_extend("force", opts, { desc = "Color picker" }))

      vim.keymap.set(
        "n",
        "<leader>cc",
        "<cmd>CccConvert<cr>",
        vim.tbl_extend("force", opts, { desc = "Convert color" })
      )

      vim.keymap.set(
        "n",
        "<leader>ct",
        "<cmd>CccHighlighterToggle<cr>",
        vim.tbl_extend("force", opts, { desc = "Toggle color highlight" })
      )

      vim.keymap.set(
        "n",
        "<leader>ce",
        "<cmd>CccHighlighterEnable<cr>",
        vim.tbl_extend("force", opts, { desc = "Enable color highlight" })
      )

      vim.keymap.set(
        "n",
        "<leader>cd",
        "<cmd>CccHighlighterDisable<cr>",
        vim.tbl_extend("force", opts, { desc = "Disable color highlight" })
      )
    end,
  },
  {
    {
      "NvChad/nvim-colorizer.lua",
      opts = {
        user_default_options = {
          tailwind = true,
        },
      },
    },
  },
}
