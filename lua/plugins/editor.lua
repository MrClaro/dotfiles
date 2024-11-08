return {
  -- Disable unnecessary plugin
  {
    enabled = false,
    "folke/flash.nvim",
    opts = {
      search = {
        forward = true,
        multi_window = false,
        wrap = false,
        incremental = true,
      },
    },
  },

  -- Highlight patterns
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {
      highlighters = {
        hsl_color = {
          pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
          group = function(_, match)
            local utils = require("solarized-osaka.hsl")
            local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
            local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
            local hex_color = utils.hslToHex(h, s, l)
            return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
          end,
        },
      },
    },
  },

  -- Git integration
  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
    opts = {
      keymaps = {
        blame = "<Leader>gb",
        browse = "<Leader>go",
      },
    },
  },

  -- Telescope with additional plugins and configurations
  {
    "telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
      { "<leader>fP", function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end, desc = "Find Plugin File" },
      { ";f", function()
          require("telescope.builtin").find_files({ no_ignore = false, hidden = true })
        end, desc = "List files in current directory (respects .gitignore)" },
      { ";r", function()
          require("telescope.builtin").live_grep({ additional_args = { "--hidden" } })
        end, desc = "Live search in directory (respects .gitignore)" },
      { "\\\\", function()
          require("telescope.builtin").buffers()
        end, desc = "List open buffers" },
      { ";t", function()
          require("telescope.builtin").help_tags()
        end, desc = "List help tags" },
      { ";;", function()
          require("telescope.builtin").resume()
        end, desc = "Resume last picker" },
      { ";e", function()
          require("telescope.builtin").diagnostics()
        end, desc = "List Diagnostics" },
      { ";s", function()
          require("telescope.builtin").treesitter()
        end, desc = "List functions and variables from Treesitter" },
      { "sf", function()
          local telescope = require("telescope")
          local function telescope_buffer_dir()
            return vim.fn.expand("%:p:h")
          end
          telescope.extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 },
          })
        end, desc = "Open File Browser in buffer path" },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = telescope.extensions.file_browser.actions

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          n = {},
        },
      })
      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = { preview_cutoff = 9999 },
        },
      }
      opts.extensions = {
        file_browser = {
          theme = "dropdown",
          hijack_netrw = true,
          mappings = {
            ["n"] = {
              ["N"] = fb_actions.create,
              ["h"] = fb_actions.goto_parent_dir,
              ["/"] = function() vim.cmd("startinsert") end,
              ["<C-u>"] = function(prompt_bufnr)
                for i = 1, 10 do actions.move_selection_previous(prompt_bufnr) end
              end,
              ["<C-d>"] = function(prompt_bufnr)
                for i = 1, 10 do actions.move_selection_next(prompt_bufnr) end
              end,
              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,
            },
          },
        },
      }
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
    end,
  },
}
