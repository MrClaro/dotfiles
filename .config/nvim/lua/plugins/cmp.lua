-- return {
--   "hrsh7th/nvim-cmp",
--
--   dependencies = {
--     { "L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" } },
--     { "mhartington/vim-angular2-snippets", lazy = true, ft = "htmlangular" },
--
--     "hrsh7th/cmp-nvim-lsp-signature-help",
--     "hrsh7th/cmp-nvim-lsp",
--     "hrsh7th/cmp-buffer",
--     "hrsh7th/cmp-path",
--     "hrsh7th/cmp-cmdline",
--     "saadparwaiz1/cmp_luasnip",
--     "VonHeikemen/lsp-zero.nvim",
--     "mlaursen/vim-react-snippets",
--
--     "hrsh7th/cmp-copilot",
--     { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
--   },
--
--   opts = function(_, opts)
--     local format_kinds = opts.formatting.format
--
--     opts.formatting.format = function(entry, item)
--       format_kinds(entry, item)
--       return require("tailwindcss-colorizer-cmp").formatter(entry, item)
--     end
--   end,
--
--   config = function(plugin, opts)
--     local cmp = require("cmp")
--     local luasnip = require("luasnip")
--     local cmp_action = require("lsp-zero").cmp_action()
--
--     local cmp_config = vim.tbl_deep_extend("force", opts, {
--       snippet = {
--         expand = function(args)
--           luasnip.lsp_expand(args.body)
--         end,
--       },
--
--       mapping = cmp.mapping({
--         ["<C-p>"] = cmp.mapping.select_prev_item(),
--         ["<C-n>"] = cmp.mapping.select_next_item(),
--         ["<CR>"] = cmp.mapping.confirm({ select = true }),
--         ["<C-Space>"] = cmp.mapping.complete(),
--         ["<C-f>"] = cmp_action.luasnip_jump_forward(),
--         ["<C-b>"] = cmp_action.luasnip_jump_backward(),
--
--         ["<Tab>"] = cmp.mapping(function(fallback)
--           local copilot_visible = vim.fn["copilot#GetDisplayedSuggestion"] ~= nil
--             and vim.fn["copilot#GetDisplayedSuggestion"]() ~= ""
--
--           local supermaven_visible = false
--           pcall(function()
--             supermaven_visible = require("supermaven-nvim.completion_preview").is_displaying()
--           end)
--
--           if supermaven_visible then
--             require("supermaven-nvim.api").accept()
--           elseif copilot_visible then
--             vim.fn.feedkeys(vim.fn["copilot#Accept"]("<Tab>"), "")
--           elseif cmp.visible() then
--             cmp.select_next_item()
--           elseif luasnip.expand_or_jumpable() then
--             luasnip.expand_or_jump()
--           else
--             fallback()
--           end
--         end, { "i", "s" }),
--       }),
--
--       sources = {
--         { name = "nvim_lsp", priority = 900 },
--         { name = "luasnip", keyword_length = 2, priority = 800 },
--         { name = "buffer", keyword_length = 3, priority = 500 },
--         { name = "path", priority = 400 },
--         { name = "nvim_lsp_signature_help", priority = 300 },
--       },
--     })
--
--     cmp.setup(cmp_config)
--
--     cmp.setup.filetype({ "css", "scss", "less" }, {
--       sources = {
--         { name = "nvim_lsp", priority = 1000 },
--         { name = "luasnip", keyword_length = 1, priority = 750 },
--         { name = "buffer", keyword_length = 3, priority = 500 },
--         { name = "path", priority = 250 },
--       },
--     })
--
--     cmp.setup.cmdline("/", {
--       mapping = cmp.mapping.preset.cmdline(),
--       sources = { { name = "buffer" } },
--     })
--
--     cmp.setup.cmdline(":", {
--       mapping = cmp.mapping.preset.cmdline(),
--       sources = cmp.config.sources({
--         { name = "path" },
--       }, {
--         { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
--       }),
--     })
--   end,
-- }

return { -- Autocompletion
  "hrsh7th/nvim-cmp",
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
      },
    },
    "saadparwaiz1/cmp_luasnip",

    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
  config = function()
    -- See `:help cmp`
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    luasnip.config.setup({})
    luasnip.filetype_extend("javascriptreact", { "html" })
    luasnip.filetype_extend("typescriptreact", { "html" })

    local kind_icons = {
      Text = "󰉿",
      Method = "m",
      Function = "󰊕",
      Constructor = "",
      Field = "",
      Variable = "󰆧",
      Class = "󰌗",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰇽",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰊄",
    }
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = "menu,menuone,noinsert" },

      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      mapping = cmp.mapping.preset.insert({
        -- Select the [n]ext item
        ["<C-n>"] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ["<C-p>"] = cmp.mapping.select_prev_item(),

        -- Scroll the documentation window [b]ack / [f]orward
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        -- ["<C-y>"] = cmp.mapping.confirm({ select = true }),

        -- If you prefer more traditional completion keymaps,
        -- you can uncomment the following lines
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        --['<Tab>'] = cmp.mapping.select_next_item(),
        --['<S-Tab>'] = cmp.mapping.select_prev_item(),

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ["<C-Space>"] = cmp.mapping.complete({}),

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ["<C-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        -- Select next/previous item with Tab / Shift + Tab
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = {
        {
          name = "lazydev",
          -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
          group_index = 0,
        },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },
    })
  end,
}
