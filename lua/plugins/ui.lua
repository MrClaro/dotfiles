  {
    "akinsho/bufferline.nvim",
    event = "BufReadPre",
    opts = {
      options = {
        mode = "buffers",
        separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
      },
    },
  },

  -- Status line customization with lualine
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          length = 0,
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
        }),
      }
    end,
  },

  -- Zen Mode for focused coding
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },

  -- Dashboard with custom logo
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[
    █████╗ ██████╗ ██████╗ ██████╗ ███████╗██╗   ██╗
   ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔════╝██║   ██║
   ███████║██║  ██║██████╔╝██║  ██║█████╗  ██║   ██║
   ██╔══██║██║  ██║██╔══██╗██║  ██║██╔══╝  ╚██╗ ██╔╝
   ██║  ██║██████╔╝██║  ██║██████╔╝███████╗ ╚████╔╝ 
   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝  ╚═══╝  
]]
      logo = string.rep("\n", 8) .. logo .. "\n\n"

      if not opts.config then
        opts.config = {}
      end

      opts.config.header = vim.split(logo, "\n")
    end,
  },

  -- Show filename at the top of the buffer with incline.nvim
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local helpers = require("incline.helpers")
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          return {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold" },
            " ",
            guibg = "#363944",
          }
        end,
      })
    end,
  },

  -- LazyGit integration for Git commands
  {
    "kdheepak/lazygit.nvim",
    keys = {
      { ";c", ":LazyGit<Return>", silent = true, noremap = true },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Database management with vim-dadbod-ui
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
      { "<leader>d", "<cmd>NeoTreeClose<cr><cmd>tabnew<cr>|<cmd>DBUI<cr>", desc = "Open DBUI" },
    },
  },
}
