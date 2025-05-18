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
    enabled = vim.tbl_contains(use_ai, "tabnine"),
    "codota/tabnine-nvim",
    build = "./dl_binaries.sh",
    config = function()
      require("tabnine").setup({
        disable_auto_comment = true,
        accept_keymap = "<Tab>",
        dismiss_keymap = "<C-]>",
        debounce_ms = 800,
        suggestion_color = { gui = "#808080", cterm = 244 },
        exclude_filetypes = { "TelescopePrompt", "NvimTree" },
        log_file_path = nil,
        ignore_certificate_errors = false,
      })
    end,
  },

  {
    enabled = vim.tbl_contains(use_ai, "supermaven"),
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_word = "<M-Right>",
        },
        color = {
          suggestion_color = "#ffffff",
          cterm = 244,
        },
      })

      -- Override suggestion color
      local function override_suggestion_color()
        vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
          group = "supermaven",
          pattern = "*",
          callback = function()
            local group_name = require("supermaven-nvim.completion_preview").suggestion_group
            vim.api.nvim_set_hl(0, group_name, {
              fg = "#ffffff",
              italic = true,
              underline = true,
            })
          end,
        })
      end

      override_suggestion_color()

      function GetStatusLineSupermaven()
        local api = require("supermaven-nvim.api")
        if api.is_running() then
          return " " -- Active
        end
        return " " -- Inactive
      end

      vim.keymap.set("n", "<F13>", ":lua SwitchCopilot()<CR>")
      vim.keymap.set("i", "<F13>", "<Esc>:lua SwitchCopilot()<CR>a")
    end,
  },

  {
    enabled = vim.tbl_contains(use_ai, "copilot"),
    "github/copilot.vim",
    config = function()
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

                :inoremap <F13> <Esc>:call ToggleCopilot()<CR>a
                :nnoremap <F13> :call ToggleCopilot()<CR>

            ]])

      -- Set Copilot suggestion color
      vim.api.nvim_set_hl(0, "CopilotSuggestion", {
        fg = "#ff0000",
        force = true,
      })
    end,
  },
  avante,
}
