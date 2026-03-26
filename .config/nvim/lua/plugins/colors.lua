return {
  -- CCC.NVIM (Color Converter and Picker)
  {
    "uga-rosa/ccc.nvim",
    event = { "VeryLazy" },
    config = function()
      local ccc = require("ccc")
      ccc.setup({
        default_color = "#000000",
        bar_char = "█",
        point_char = "◉",
        point_color = "",
        empty_point_bg = false,
        auto_close = true,
        preserve = false,
        alpha_show = "auto",
        win_opts = {
          relative = "cursor",
          row = 1,
          col = 1,
          style = "minimal",
          border = "rounded",
        },
        recognize = { input = true, output = true },
        highlighter = {
          auto_enable = false,
          max_byte = 100 * 1024,
          update_insert = true,
          filetypes = {
            "css",
            "scss",
            "sass",
            "less",
            "stylus",
            "html",
            "javascript",
            "typescript",
            "jsx",
            "tsx",
            "vue",
            "svelte",
            "lua",
            "vim",
            "conf",
            "config",
          },
          excludes = { "lazy", "mason", "help", "neo-tree" },
        },
      })
      vim.keymap.set("n", "<leader>cp", "<cmd>CccPick<cr>", { desc = "Color picker" })
      vim.keymap.set("n", "<leader>cc", "<cmd>CccConvert<cr>", { desc = "Convert color" })
    end,
  },
}
