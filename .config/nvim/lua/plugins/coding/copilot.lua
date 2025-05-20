local use_ai = {
  -- "avante",
  "copilot",
  -- "tabnine",
  "supermaven",
}

function SwitchCopilot()
  -- Switch between Supermaven and Copilot
  local supermavenapi = require("supermaven-nvim.api")

  if supermavenapi.is_running() then
    supermavenapi.stop()
    vim.notify("Switched to Copilot", vim.log.levels.INFO, { title = "AI Status" })

    if vim.fn.exists(":Copilot") == 2 then
      vim.cmd("Copilot enable")
    else
      vim.notify("Copilot command not found", vim.log.levels.ERROR)
    end
  else
    supermavenapi.start()
    vim.notify("Switched to Supermaven", vim.log.levels.INFO, { title = "AI Status" })

    if vim.fn.exists(":Copilot") == 2 then
      vim.cmd("Copilot disable")
    else
      vim.notify("Copilot command not found", vim.log.levels.ERROR)
    end
  end
end

function SupermavenIsVisible()
  local ok, preview = pcall(require, "supermaven-nvim.completion_preview")
  return ok and preview.is_displaying()
end

-- Configuration for Avante if needed
local avante = {
  enabled = vim.tbl_contains(use_ai, "avante"),
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change

  opts = {
    -- Defaults to Copilot, can try Claude or Copilot
    provider = "copilot",
    behaviour = {
      auto_suggestions = true,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
    },
  },

  build = "make", -- build process for Avante
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim", -- for vim.ui.select
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim", -- ui component library
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
  },
}

-- Ensure compatibility with Neovim version 0.10+
local version = vim.version()
if version.major == 0 and version.minor < 10 then
  avante = {}
end

return {

  {
    enabled = vim.tbl_contains(use_ai, "supermaven"),
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-y>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
        ignore_filetypes = { cpp = true }, -- or { "cpp", }
        color = {
          suggestion_color = "#ffffff",
          cterm = 244,
        },
        log_level = "info", -- set to "off" to disable logging completely
        disable_inline_completion = false, -- disables inline completion for use with cmp
        disable_keymaps = false, -- disables built in keymaps for more manual control
        condition = function()
          return false
        end,
      })
      function GetStatusLineSupermaven()
        local api = require("supermaven-nvim.api")
        if api.is_running() then
          return " " -- Active
        end
        return " " -- Inactive
      end

      vim.keymap.set("n", "<F8>", ":lua SwitchCopilot()<CR>")
      vim.keymap.set("i", "<F8>", "<Esc>:lua SwitchCopilot()<CR>a")
    end,
  },

  {
    enabled = vim.tbl_contains(use_ai, "copilot"),
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true

      vim.api.nvim_set_keymap(
        "i",
        "<Tab>",
        'copilot#Accept("<Tab>")',
        { expr = true, silent = true, noremap = true, replace_keycodes = false }
      )

      vim.cmd([[
      function! GetStatusLineCopilot()
        if exists('*copilot#Enabled') && copilot#Enabled()
          return ' '
        else
          return ' '
        endif
      endfunction

      function! ToggleCopilot()
        if copilot#Enabled()
          Copilot disable
        else
          Copilot enable
        endif
      endfunction

      :inoremap <F8> <Esc>:call ToggleCopilot()<CR>a
      :nnoremap <F8> :call ToggleCopilot()<CR>
    ]])

      -- Set Copilot suggestion color
      vim.api.nvim_set_hl(0, "CopilotSuggestion", {
        fg = "#963e7c",
        force = true,
      })
    end,
  },

  avante,
}
