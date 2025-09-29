return {
  -- CCC.NVIM (Color Converter and Picker)
  {
    "uga-rosa/ccc.nvim",
    event = { "BufReadPre", "BufNewFile" },
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
          auto_enable = true,
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

      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>cp", "<cmd>CccPick<cr>", vim.tbl_extend("force", opts, { desc = "Color picker" }))
      vim.keymap.set(
        "n",
        "<leader>cc",
        "<cmd>CccConvert<cr>",
        vim.tbl_extend("force", opts, { desc = "Convert color" })
      )
      vim.keymap.set(
        "n",
        "<leader>ct",
        "<cmd>CccHighlighterToggle<cr>",
        vim.tbl_extend("force", opts, { desc = "Toggle color highlight" })
      )
      vim.keymap.set(
        "n",
        "<leader>ce",
        "<cmd>CccHighlighterEnable<cr>",
        vim.tbl_extend("force", opts, { desc = "Enable color highlight" })
      )
      vim.keymap.set(
        "n",
        "<leader>cd",
        "<cmd>CccHighlighterDisable<cr>",
        vim.tbl_extend("force", opts, { desc = "Disable color highlight" })
      )
    end,
  },

  -- NVIM-COLORIZER.LUA (Highlight colors in CSS, HTML, etc.)
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },
}
