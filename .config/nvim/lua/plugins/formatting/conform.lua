-- Define the filetypes Prettier should handle
local prettier_supported_filetypes = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
      end,
      mode = { "n", "v" },
      desc = "Format Injected Langs",
    },
  },
  init = function()
    LazyVim.on_very_lazy(function()
      LazyVim.format.register({
        name = "conform.nvim",
        priority = 100,
        primary = true,
        format = function(buf)
          require("conform").format({ bufnr = buf })
        end,
        sources = function(buf)
          local ret = require("conform").list_formatters(buf)
          return vim.tbl_map(function(v)
            return v.name
          end, ret)
        end,
      })
    end)
  end,
  opts = function()
    local opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        scss = { "prettier" },
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        xml = { "xmllint" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        prettierd = {
          condition = function(ctx)
            return vim.fn.executable("prettierd") == 1
              and vim.fs.find(
                { ".prettierrc", ".prettierrc.json", ".prettierrc.js", "prettier.config.js", "package.json" },
                { path = ctx.filename, upward = true }
              )[1]
          end,
        },
        prettier = {
          condition = function(ctx)
            return vim.fn.executable("prettier") == 1
              and vim.fs.find(
                { ".prettierrc", ".prettierrc.json", ".prettierrc.js", "prettier.config.js", "package.json" },
                { path = ctx.filename, upward = true }
              )[1]
          end,
        },
      },
    }

    for _, ft in ipairs(prettier_supported_filetypes) do
      opts.formatters_by_ft[ft] = { "prettierd", "prettier" }
    end

    return opts
  end,
}
