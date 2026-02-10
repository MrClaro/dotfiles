return {

  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true

      vim.keymap.set("i", "<C-y>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion",
      })
      vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot" })
      vim.keymap.set("i", "<C-j>", "<Plug>(copilot-accept-word)", { desc = "Accept word" })
      vim.keymap.set("i", "<C-l>", "<Plug>(copilot-next)", { desc = "Next suggestion" })
      vim.keymap.set("i", "<C-h>", "<Plug>(copilot-previous)", { desc = "Previous suggestion" })

      vim.keymap.set("n", "<leader>cp", ":Copilot toggle<CR>", { desc = "Toggle Copilot" })

      vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#963e7c", italic = true })
    end,
  },
}
