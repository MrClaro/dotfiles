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
    },
    keys = {
      name = "🔧 Git",
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "📘 Open LazyGit" },
      { "<leader>lf", "<cmd>LazyGitFilter<cr>", desc = "🔍 Filter Git changes" },
      { "<leader>lc", "<cmd>LazyGitConfig<cr>", desc = "⚙️ Open LazyGit Config" },
    },
  },

  -- Quarto for Literate Programming
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("quarto").setup()
    end,
    keys = {
      name = "📚 Quarto",
      { "<leader>qv", "<cmd>QuartoPreview<cr>", desc = "🖥️ Preview Quarto document" },
      { "<leader>qc", "<cmd>QuartoClosePreview<cr>", desc = "❌ Close Quarto preview" },
    },
  },
  -- Comment code easily
  {
    "tpope/vim-commentary",
    keys = {
      name = "💬 Comment",
      { "<leader>rc", "<cmd>Commentary<cr>", desc = "📝 Toggle comment" },
    },
  },
  -- Database Management with DBUI
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
    keys = {
      name = "🗄 Database",
      { "<leader>lb", "<cmd>DBUI<cr>", desc = "📂 Open DBUI" },
      { "<leader>lB", "<cmd>DBUIToggle<cr>", desc = "🔄 Toggle DBUI" },
      { "<leader>la", "<cmd>DBUIAddConnection<cr>", desc = "➕ Add new DB connection" },
    },
  },
  -- HTTP Client Configuration
  {
    "rest-nvim/rest.nvim",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("rest-nvim").setup({
        result_split_horizontal = false,
        result_split_in_place = false,
        stay_in_current_window_after_split = false,
        skip_ssl_verification = false,
        encode_url = true,
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          show_url = true,
          show_curl_command = false,
          show_http_info = true,
          show_headers = true,
          show_statistics = false,
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end,
          },
        },
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
        search_back = true,
      })
    end,
    keys = {
      {
        "<leader>lr",
        "<cmd>Rest open --url <cr>",
        desc = "🌐 Test the current HTTP request",
      },
      {
        "<leader>lt",
        "<cmd>Rest cookies <ct>",
        desc = "🍪 Edit the cookies for the current request",
      },
      {
        "<leader>ls",
        "<cmd>Rest run <cr>",
        desc = "🚀 Run the current HTTP request",
      },
    },
  },
}
