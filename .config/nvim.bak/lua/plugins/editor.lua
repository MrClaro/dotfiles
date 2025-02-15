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
  -- Hihglight colors
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },
}
