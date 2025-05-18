return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v4.x",

  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },

  config = function()
    local lsp = require("lsp-zero")
    lsp.preset("recommended")

    require("mason").setup({
      registries = {
        "github:nvim-java/mason-registry",
        "github:mason-org/mason-registry",
      },
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "jsonls",
        "html",
        "tailwindcss",
        "tflint",
        "pylsp",
        "dockerls",
        "bashls",
        "marksman",
        "gopls",
        "emmet_ls",
        "cssls",
        "yamlls",
        "taplo",
        "vtsls",
      },
      handlers = {
        lsp.default_setup,
        lua_ls = function()
          local lua_opts = lsp.nvim_lua_ls()
          require("lspconfig").lua_ls.setup(lua_opts)
        end,
        vtsls = function()
          require("lspconfig").vtsls.setup({
            settings = {
              typescript = {
                inlayHints = {
                  parameterNames = { enabled = "all" },
                  variableTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  enumMemberValues = { enabled = true },
                },
              },
            },
          })
        end,
      },
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        "stylua",
        "prettier",
        "prettierd",
        "google-java-format",
        "htmlbeautifier",
        "beautysh",
        "buf",
        "yamlfix",
        "taplo",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "eslint_d",
        "standardrb",
      },
    })

    lsp.on_attach(function(client, bufnr)
      local opts = { buffer = bufnr }
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>fs", vim.lsp.buf.signature_help, opts)

      if vim.lsp.inlay_hint then
        local hints_enabled = false
        vim.keymap.set("n", "<leader>th", function()
          hints_enabled = not hints_enabled
          local ok, err = pcall(vim.lsp.inlay_hint.enable, bufnr, hints_enabled)
          if not ok then
            vim.notify("Erro ao alternar inlay hints: " .. err, vim.log.levels.ERROR)
          end
        end, { desc = "Toggle Inlay Hints", buffer = bufnr })
      end
    end)

    lsp.setup()
  end,
}
