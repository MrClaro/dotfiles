return {
  "nvim-mini/mini.nvim",
  version = false,
  config = function()
    require("mini.ai").setup()
    require("mini.surround").setup()
    require("mini.cursorword").setup()
    require("mini.move").setup()
  end,
}
