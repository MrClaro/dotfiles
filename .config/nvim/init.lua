if G == nil then
  G = {}
end

require("config.lazy")
local scss_module = require("utils.scss_compiler")
scss_module.setup()

vim.api.nvim_create_autocmd("FileType", {
  pattern = "htmlangular",
  callback = function()
    vim.bo.filetype = "html"
    print("🔄 Converted htmlangular → html")
  end,
  desc = "Force htmlangular to html",
  group = vim.api.nvim_create_augroup("ForceHtmlAngular", { clear = true }),
})

local ls = require("luasnip")

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets/" })

ls.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
})
