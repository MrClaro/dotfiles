return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v2.x",

  dependencies = {
    -- LSP Support
    { "neovim/nvim-lspconfig" },
    {
      "williamboman/mason.nvim",
      build = function()
        pcall(vim.cmd, "MasonUpdate")
      end,
    },
    { "williamboman/mason-lspconfig.nvim" },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },

    -- Autocompletion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "L3MON4D3/LuaSnip" },
    { "rafamadriz/friendly-snippets" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "saadparwaiz1/cmp_luasnip" },
  },

  config = function()
    local lsp = require("lsp-zero")
    lsp.preset("recommended")

    -- mason setup
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
      },
      handlers = {
        lsp.default_setup,
        lua_ls = function()
          local lua_opts = lsp.nvim_lua_ls()
          require("lspconfig").lua_ls.setup(lua_opts)
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
    end)

    -- nvim-cmp setup
    local cmp_action = require("lsp-zero").cmp_action()

    local ok_cmp, cmp = pcall(require, "cmp")
    if not ok_cmp then
      vim.notify("nvim-cmp cannot be loaded!", vim.log.levels.ERROR)
      return
    end

    local ok_luasnip, luasnip = pcall(require, "luasnip")
    if ok_luasnip then
      require("luasnip.loaders.from_vscode").lazy_load()
    else
      vim.notify("LuaSnip cannot be loaded!", vim.log.levels.ERROR)
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-f>"] = cmp_action.luasnip_jump_forward(),
        ["<C-b>"] = cmp_action.luasnip_jump_backward(),
        ["<Tab>"] = cmp_action.luasnip_supertab(),
        ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip", keyword_length = 2 },
        { name = "buffer", keyword_length = 3 },
        { name = "path" },
      },
    })

    -- cmdline completion
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    lsp.setup()
  end,
}
