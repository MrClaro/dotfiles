-- COC Nvim Integration
return {
  "neoclide/coc.nvim",
  branch = "release",
  lazy = false,
  init = function()
    vim.g.coc_global_extensions = {
      "coc-json",
      "coc-tsserver",
      "coc-html",
      "coc-css",
      "coc-angular",
    }
  end,
  config = function() end,
}
