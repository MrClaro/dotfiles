return {
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSUpdate" },
    config = function()
      vim.defer_fn(function()
        local status_ok, configs = pcall(require, "nvim-treesitter.configs")
        if not status_ok then
          --         vim.notify("nvim-treesitter.configs not found, trying to install...", vim.log.levels.WARN)
          vim.cmd("TSUpdate")
          return
        end

        configs.setup({
          ensure_installed = {
            "astro",
            "bash",
            "blade",
            "c",
            "caddy",
            "css",
            "diff",
            "dockerfile",
            "editorconfig",
            "gitignore",
            "go",
            "gomod",
            "gosum",
            "html",
            "javascript",
            "java",
            "json",
            "lua",
            "luadoc",
            "nginx",
            "php",
            "php_only",
            "python",
            "sql",
            "typescript",
            "vim",
            "vimdoc",
            "ninja",
            "rst",
          },
          -- Autoinstall languages that are not installed
          auto_install = true,
          highlight = {
            enable = true,
            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            --  If you are experiencing weird indenting issues, add the language to
            --  the list of additional_vim_regex_highlighting and disabled languages for indent.
            additional_vim_regex_highlighting = { "ruby" },
          },
          indent = { enable = true, disable = { "ruby" } },
        })
      end, 100) -- Aguarda 100ms para garantir que tudo carregou
    end,
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}
