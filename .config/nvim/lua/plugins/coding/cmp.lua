return {
  "hrsh7th/nvim-cmp",

  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "VonHeikemen/lsp-zero.nvim",
  },

  config = function()
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
  end,
}
