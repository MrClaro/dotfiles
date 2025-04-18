return {

  -- Messages, cmdline, and popup menu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      -- Add a rule to filter specific messages
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available", -- Ignore messages containing "No information available"
        },
        opts = { skip = true },
      })

      -- Track window focus status
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })

      -- Show notifications when the window is not focused
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send", -- Displays notifications in a native style
        opts = { stop = false }, -- Allows other notifications to continue displaying
      })

      -- Command settings to show message history in noice.nvim
      opts.commands = {
        all = {
          view = "split",
          opts = { enter = true, format = "details" },
        },
      }

      -- Enable border for LSP documentation
      opts.presets.lsp_doc_border = true
    end,
  },

  -- Notification system
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000, -- Set notification timeout to 5 seconds
    },
  },

  -- Smooth animations
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.scroll = { enable = false } -- Disable scrolling animation
    end,
  },
  -- Buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
    },
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
}
