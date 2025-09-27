vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "htmlangular",
  callback = function()
    require("lspconfig").angularls.setup({})
  end,
  group = vim.api.nvim_create_augroup("AngularLSPSetup", { clear = true }),
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.html", "*.component.html" },
  callback = function(data)
    local project_root = require("lspconfig.util").root_pattern("angular.json", "tsconfig.json")(data.file)

    if project_root ~= nil and project_root ~= "" then
      vim.bo[data.buf].filetype = "htmlangular"
    else
      vim.bo[data.buf].filetype = "html"
    end
  end,
  group = vim.api.nvim_create_augroup("AngularFiletypeGroup", { clear = true }),
})
