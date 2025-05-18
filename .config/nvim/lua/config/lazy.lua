local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- ✅ LazyVim core (deve vir primeiro)
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- ✅ LazyVim extras (se houver)
    -- { import = "lazyvim.plugins.extras.lang.java" },
    -- { import = "lazyvim.plugins.extras.coding.luasnip" },
    -- { import = "lazyvim.plugins.extras.dap.core" },

    -- ✅ Seus plugins (depois dos imports LazyVim)
    { import = "plugins.coding" },
    { import = "plugins.dap" },
    --   { import = "plugins.formating" },
    { import = "plugins.integrations" },
    { import = "plugins.languages" },
    { import = "plugins.test" },
    { import = "plugins.ui" },

    -- Plugins extras manuais (também depois de tudo)
    {
      "L3MON4D3/LuaSnip",
      enabled = true,
    },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "catppuccin-mocha" } },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      -- Nota: esse bloco `{ "L3MON4D3/LuaSnip", enabled = true }` aqui é redundante com o de cima
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
