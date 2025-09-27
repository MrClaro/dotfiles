return {
  "hrsh7th/nvim-cmp",

  dependencies = {
    { "L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" } },
    { "mhartington/vim-angular2-snippets", lazy = true, ft = "htmlangular" },

    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "VonHeikemen/lsp-zero.nvim",
    "mlaursen/vim-react-snippets",
    { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
  },

  opts = function(_, opts)
    local format_kinds = opts.formatting.format

    opts.formatting.format = function(entry, item)
      format_kinds(entry, item)
      return require("tailwindcss-colorizer-cmp").formatter(entry, item)
    end
  end,

  config = function(plugin, opts)
    local cmp = require("cmp") -- Sem pcall para simplificar a lógica
    local luasnip = require("luasnip")

    local cmp_action = require("lsp-zero").cmp_action()

    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip").filetype_extend("htmlangular", { "html" })

    local ok, custom_angular_snippets = pcall(require, "snippets.angular")

    if ok then
      if type(custom_angular_snippets) == "table" and not vim.tbl_isempty(custom_angular_snippets) then
        vim.notify(
          "Snippets do Angular carregados com sucesso! Total: " .. #custom_angular_snippets,
          vim.log.levels.INFO
        )

        require("luasnip").add_snippets("htmlangular", custom_angular_snippets)
      else
        vim.notify(
          "ERRO: Módulo de snippets 'snippets.angular' encontrado, mas está vazio ou não retornou uma tabela de snippets.",
          vim.log.levels.WARN
        )
      end
    else
      vim.notify(
        "FALHA CRÍTICA: Não foi possível encontrar ou carregar o módulo 'snippets.angular'. Verifique o caminho.",
        vim.log.levels.ERROR
      )
      vim.notify("Detalhes do erro: " .. tostring(custom_angular_snippets), vim.log.levels.ERROR)
    end

    require("vim-react-snippets").lazy_load()
    local config = require("vim-react-snippets.config")
    config.readonly_props = false

    local cmp_config = vim.tbl_deep_extend("force", opts, {
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

        ["<Tab>"] = cmp.mapping(function(fallback)
          local copilot_visible = vim.fn["copilot#GetDisplayedSuggestion"] ~= nil
            and vim.fn["copilot#GetDisplayedSuggestion"]() ~= ""

          local supermaven_visible = false
          pcall(function()
            supermaven_visible = require("supermaven-nvim.completion_preview").is_displaying()
          end)

          if supermaven_visible then
            require("supermaven-nvim.api").accept()
          elseif copilot_visible then
            vim.fn.feedkeys(vim.fn["copilot#Accept"]("<Tab>"), "")
          elseif cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip", keyword_length = 2 },
        { name = "buffer", keyword_length = 3 },
        { name = "path" },
        { name = "nvim_lsp_signature_help" },
      },
    })

    cmp.setup(cmp_config)

    cmp.setup.filetype({ "css", "scss", "less" }, {
      sources = {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", keyword_length = 1, priority = 750 },
        { name = "buffer", keyword_length = 3, priority = 500 },
        { name = "path", priority = 250 },
      },
    })

    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = "buffer" } },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
      }),
    })
  end,
}
