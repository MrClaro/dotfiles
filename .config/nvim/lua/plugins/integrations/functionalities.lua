return {
  -- Flash navigation plugin
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    -- stylua: ignore
    keys = {
      { "zk", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "Zk", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- Typst preview plugin
  {
    "chomosuke/typst-preview.nvim",
    lazy = false, -- or ft = 'typst'
    version = "1.*",
    opts = {
      invert_colors = "always",
    },
    build = function()
      require("typst-preview").update()
    end,
  },

  -- Typst syntax support
  {
    "kaarmu/typst.vim",
    ft = "typst",
    enabled = not vim.g.vscode,
    lazy = false,
  },

  -- Auto-close and rename HTML/XML tags
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
        -- Override individual filetype configs, these take priority
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        per_filetype = {
          ["html"] = {
            enable_close = false,
          },
        },
      })
    end,
  },

  -- Remote Neovim development
  {
    "amitds1997/remote-nvim.nvim",
    version = "*", -- Pin to GitHub releases
    dependencies = {
      "nvim-lua/plenary.nvim", -- For standard functions
      "MunifTanjim/nui.nvim", -- To build the plugin UI
      "nvim-telescope/telescope.nvim", -- For picking between different remote methods
    },
    config = true,
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- Startup time measurement
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Surround text objects
  {
    "kylechui/nvim-surround",
    version = "^3.0.0",
    event = "VeryLazy", -- Fixed typo from "vent"
    config = function()
      require("nvim-surround").setup({
        -- Define new mappings for Normal and Visual modes
        keymaps = {
          normal = "gs", -- Use 'gs' as the prefix for nvim-surround in Normal mode
          -- Example: 'gs' + 'iw' + ')' to surround words
          visual = "gS", -- Use 'gS' as the prefix for nvim-surround in Visual mode
          -- Example: select text and then 'gS' + ')'
          delete = "ds", -- Mapping to delete surround
          change = "cs", -- Mapping to change surround
        },
      })
    end,
  },

  -- Color highlighter
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "*",
        css = { rgb_fn = true },
      })
    end,
  },

  -- CSV file viewer
  {
    "hat0uma/csvview.nvim",
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place cursor at field end.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },
}
