local use_ai = { "copilot", "supermaven" }

return {
  -- 1. SUPERMAVEN
  {
    enabled = vim.tbl_contains(use_ai, "supermaven"),
    "supermaven-inc/supermaven-nvim",
    config = function()
      local manager = require("utils.ai_manager")
      local current_ai_state = manager.GetCurrentAIState()

      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-y>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
        ignore_filetypes = { cpp = true },
        color = { suggestion_color = "#963e7c", cterm = 244 },
        log_level = "info",
        disable_inline_completion = false,
        disable_keymaps = false,

        condition = function()
          return manager.GetCurrentAIState() == 1
        end,
      })

      vim.keymap.set("n", "<F8>", manager.CycleAI, { desc = "Cycle AI (Supermaven/Copilot)" })
      vim.keymap.set(
        "i",
        "<F8>",
        "<Esc>:lua require('utils.ai_manager').CycleAI()<CR>a",
        { desc = "Cycle AI (Insert)" }
      )

      vim.defer_fn(function()
        manager.SwitchToAI(current_ai_state)
      end, 100)
    end,
  },

  -- 2. SUPERMAVEN
  {
    enabled = vim.tbl_contains(use_ai, "copilot"),
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#963e7c", force = true })
    end,
  },
}
