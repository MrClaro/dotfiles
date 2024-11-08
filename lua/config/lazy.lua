-- Set path for lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is already installed, if not, clone it
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  
  -- If cloning fails, show an error message and exit
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Lazy plugin setup
require("lazy").setup({
  spec = {
    -- LazyVim plugin and configuration
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "catppuccin",  -- Use the 'catppuccin' theme
        news = {
          lazyvim = true,
          neovim = true,
        },
      },
    },
    -- Linting and formatting plugins
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    
    -- Utilities and extra plugins
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
    { import = "plugins" },  -- Custom user plugins
  },

  -- Default settings for plugins
  defaults = {
    lazy = false,  -- Disable lazy-loading by default
    version = false,  -- Always use the latest commit from plugins
  },

  -- Development setup (path for custom development plugins)
  dev = {
    path = "~/.ghq/github.com",
  },

  -- Plugin update checker
  checker = { enabled = true },  -- Automatically check for updates

  -- Performance optimizations
  performance = {
    cache = { enabled = true },  -- Enable cache for performance
    rtp = {
      -- Disable certain runtime path plugins for faster startup
      disabled_plugins = {
        "gzip",  -- Compression
        "netrwPlugin",  -- File explorer
        "rplugin",  -- Remote plugins
        "tarPlugin",  -- TAR support
        "tohtml",  -- HTML export
        "tutor",  -- Tutor mode
        "zipPlugin",  -- ZIP support
      },
    },
  },

  -- UI customizations
  ui = {
    custom_keys = {
      ["<localleader>d"] = function(plugin)
        dd(plugin)  -- Custom keybinding for displaying plugin info
      end,
    },
  },

  -- Debugging settings
  debug = false,  -- Disable debug logs
})
