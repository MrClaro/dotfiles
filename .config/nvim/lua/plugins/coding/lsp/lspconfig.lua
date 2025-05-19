return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim" },
    { "jay-babu/mason-nvim-dap.nvim" },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        {
          "stevearc/overseer.nvim",
          config = true,
          opts = {
            dap = false,
          },
        },
      },
    },
    {
      "stevearc/conform.nvim",
      opts = {},
    },
    { "L3MON4D3/LuaSnip" },
    {
      "hrsh7th/nvim-cmp",
    },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-path" },
    {
      "kevinhwang91/nvim-ufo",
      dependencies = { "kevinhwang91/promise-async" },
    },
    {
      "saadparwaiz1/cmp_luasnip",
    },
    { "williamboman/mason-lspconfig.nvim" },
    { "onsails/lspkind.nvim" },
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
    {
      "rafamadriz/friendly-snippets",
    },
    {
      "ray-x/lsp_signature.nvim",
    },
    {
      "rcarriga/cmp-dap",
    },
    {
      "mrcjkb/rustaceanvim",
      version = "^6", -- Recommended
      lazy = false, -- This plugin is already lazy
    },
  },
  config = function()
    --#region JS/TS Setup. ---------------------------------------------

    require("typescript-tools").setup({
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
      },
      settings = {
        tsserver_plugins = {
          "@vue/typescript-plugin",
        },
      },
    })
    --#endregion JS/TS Setup. ---------------------------------------------

    --#region common Lsp shortcut.
    require("conform").formatters.odinfmt = {
      inherit = false,
      command = "odinfmt",
      args = { "-stdin" },
      stdin = function()
        local file_contents = vim.fn.readfile(vim.fn.expand("%"))
        return table.concat(file_contents, "\n")
      end,
    }
    require("conform").setup({
      formatters_by_ft = {
        lua = { lsp_format = "fallback" },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        odin = { "odinfmt" },
        just = { "just" },
        typst = { "typstfmt" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
      callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover({
            border = "rounded",
          })
        end, { desc = "Show hover information", unpack(opts) })
        vim.keymap.set("n", "<leader>vws", function()
          vim.lsp.buf.workspace_symbol()
        end, { desc = "List workspace symbols", unpack(opts) })
        vim.keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, { desc = "Go to next diagnostic", unpack(opts) })
        vim.keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, { desc = "Go to previous diagnostic", unpack(opts) })
        vim.keymap.set("n", "<M-CR>", function()
          vim.lsp.buf.code_action()
        end, { desc = "Show code actions", unpack(opts) })
        vim.keymap.set("n", "<leader>vrr", function()
          vim.lsp.buf.references()
        end, { desc = "Find references", unpack(opts) })
        vim.keymap.set("n", "<leader>vrn", function()
          vim.lsp.buf.rename()
        end, { desc = "Rename symbol", unpack(opts) })
        vim.keymap.set("i", "<C-h>", function()
          vim.lsp.buf.signature_help()
        end, { desc = "Show signature help", unpack(opts) })
        vim.keymap.set("n", "<space>eE", vim.diagnostic.open_float, { desc = "Show error on cursor", unpack(opts) })
        vim.keymap.set({ "n" }, "<Leader>K", function()
          vim.lsp.buf.signature_help()
        end, { silent = true, noremap = true, desc = "toggle signature" })
        vim.keymap.set("n", "<leader>f", require("conform").format, { desc = "Format buffer" })
      end,
    })
    --#endregion

    --#region Lsp signature popup on typing arg.
    local signature = require("lsp_signature")
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local bufnr = args.buf
        signature.on_attach({
          bind = true, -- This is mandatory, otherwise border config won't get registered.
          max_height = 3,
          handler_opts = {
            border = "rounded",
          },
          floating_window_off_x = 5, -- adjust float windows x position.
          floating_window_off_y = function() -- adjust float windows y position.
            -- e.g. Set to -2 can make floating window move up 2 lines
            local pumheight = vim.o.pumheight
            local winline = vim.fn.winline() -- line number in the window
            local winheight = vim.fn.winheight(0)

            -- window top
            if winline - 1 < pumheight then
              return pumheight
            end

            -- window bottom
            if winheight - winline < pumheight then
              return -pumheight
            end
            return 0
          end,
        }, bufnr)
      end,
    })
    --#endregion

    --#region Lsp server setup and fold provider setup.
    local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

    lsp_capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    -- ufo Config use to fold code.

    vim.o.foldcolumn = "1" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

    require("mason").setup({
      registries = {
        "github:mason-org/mason-registry",
      },
    })
    local function get_clangd_cmd()
      local project_path = vim.fn.getcwd() -- Get the current project directory

      -- Define the paths for Mason and Xcode clangd
      local mason_clangd = "clangd"
      local xcode_clangd = "/usr/bin/clangd"

      -- Define project-specific rules
      if string.match(project_path, ".*XcodeProject.*") then
        return xcode_clangd
      else
        return mason_clangd
      end
    end

    local clangd_cap = lsp_capabilities
    clangd_cap.offsetEncoding = { "utf-16" }
    require("lspconfig")["clangd"].setup({
      capabilities = clangd_cap,
      cmd = {
        get_clangd_cmd(),
        "--background-index",
        "--header-insertion-decorators",
        "--fallback-style=Google",
        "--header-insertion=never",
        "--background-index-priority=normal",
        "--enable-config",
        "--clang-tidy",
      },
    })
    vim.g.rustaceanvim = {
      server = {
        cmd = function()
          local mason_registry = require("mason-registry")
          if mason_registry.is_installed("rust-analyzer") then
            -- This may need to be tweaked depending on the operating system.
            local ra = mason_registry.get_package("rust-analyzer")
            local ra_filename = ra:get_receipt():get().links.bin["rust-analyzer"]
            return { ("%s/%s"):format(ra:get_install_path(), ra_filename or "rust-analyzer") }
          else
            -- global installation
            return { "rust-analyzer" }
          end
        end,
      },
    }

    require("mason-lspconfig").setup({
      ensure_installed = { "clangd", "bashls", "neocmake", "lua_ls", "marksman" },
    })
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        if server_name == "ts_ls" or server_name == "clangd" then
          return
        end
        require("lspconfig")[server_name].setup({
          capabilities = lsp_capabilities,
        })
      end,
      ["bashls"] = function()
        require("lspconfig").bashls.setup({
          capabilities = lsp_capabilities,
          filetypes = { "bash", "sh", "just" },
        })
      end,
      ["lua_ls"] = function()
        require("lspconfig").lua_ls.setup({
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if
                path ~= vim.fn.stdpath("config")
                and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
              then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
            })
          end,
          settings = {
            Lua = {},
          },
        })
      end,
      ["rust_analyzer"] = function() end,
      ["zls"] = function()
        require("lspconfig").zls.setup({
          cmd = {
            "zls",
            "--config-path",
            "~/.config/nvim/lsp_config/zls.json",
          },
        })
      end,
    })

    -- temp Solve for rust update interrupted typing.
    -- https://github.com/neovim/neovim/issues/30985
    for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
      local default_diagnostic_handler = vim.lsp.handlers[method]
      vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
          return
        end
        return default_diagnostic_handler(err, result, context, config)
      end
    end
    require("lspconfig").gdscript.setup(lsp_capabilities)

    require("ufo").setup()
    --#endregion

    --#region dap
    require("mason-nvim-dap").setup({
      ensure_installed = { "codelldb" },
      handlers = {
        function(config)
          -- all sources with no handler get passed here

          -- Keep original functionality
          require("mason-nvim-dap").default_setup(config)
        end,
        codelldb = function(config)
          config.configurations = {}
          -- In Some how, apple codelldb will auto add some breakpoint,
          -- not sure it came form apple codelldb or something
          require("dap").defaults.codelldb.exception_breakpoints = {}

          require("mason-nvim-dap").default_setup(config)
        end,
      },
    })

    local dap, dapui = require("dap"), require("dapui")

    dapui.setup()

    dap.adapters.godot = {
      type = "server",
      host = "127.0.0.1",
      port = 6006,
    }

    dap.configurations.gdscript = {
      {
        type = "godot",
        request = "launch",
        name = "Launch scene",
        project = "${workspaceFolder}",
        launch_scene = true,
      },
    }

    vim.api.nvim_set_keymap("n", "<F5>", '<Cmd>lua require"dap".continue()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap(
      "n",
      "<F9>",
      '<Cmd>lua require"dap".toggle_breakpoint()<CR>',
      { noremap = true, silent = true }
    )
    vim.api.nvim_set_keymap("n", "<F10>", '<Cmd>lua require"dap".step_over()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<F11>", '<Cmd>lua require"dap".step_into()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<S-F11>", '<Cmd>lua require"dap".step_out()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<S-F5>", '<Cmd>lua require"dap".terminate()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap(
      "n",
      "<Leader>tf",
      '<Cmd>lua require("dapui").float_element() <CR>',
      { noremap = true, silent = true }
    )

    vim.api.nvim_set_keymap(
      "n",
      "<Leader>tt",
      '<Cmd>lua require("dapui").toggle() <CR>',
      { noremap = true, silent = true }
    )

    require("overseer").enable_dap()
    --#endregion

    --#region Show error on hold.
    local ns = vim.api.nvim_create_namespace("my_diagnostics_ns")

    vim.diagnostic.config({
      virtual_text = false,
      underline = true,
    })

    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local lnum = cursor[1] - 1
        local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })

        if #diagnostics > 0 then
          vim.diagnostic.show(ns, bufnr, diagnostics, {
            virtual_text = true,
          })
        end
      end,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        vim.diagnostic.hide(ns)
        vim.diagnostic.config({
          virtual_text = false,
          underline = true,
        })
      end,
    })
    --#endregion Show error on hold.

    --#region luasnip setup
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    local lspkind = require("lspkind")
    local cmp = require("cmp")
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    cmp.setup({
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip", keyword_length = 2 },
        { name = "path" },
        { name = "buffer", keyword_length = 3 },
      },
      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-e>"] = cmp.mapping.abort(),
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, vim_item)
          local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
          local strings = vim.split(kind.kind, "%s", { trimempty = true })
          kind.kind = " " .. (strings[1] or "") .. " "
          kind.menu = "    " .. (strings[2] or "")

          return kind
        end,
      },
      enabled = function()
        local disabled = false
        disabled = disabled
          or (vim.api.nvim_buf_get_option(0, "buftype") == "prompt" and not require("cmp_dap").is_dap_buffer())
        disabled = disabled or (vim.fn.reg_recording() ~= "")
        disabled = disabled or (vim.fn.reg_executing() ~= "")
        return not disabled
      end,
    })

    local cmdline_mappings = cmp.mapping.preset.cmdline()

    cmdline_mappings["<C-P>"] = nil
    cmdline_mappings["<C-N>"] = nil
    require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
      sources = {
        { name = "dap", keyword_length = 0 },
      },
    })

    cmp.setup.cmdline("/", {
      mapping = cmdline_mappings,
      sources = {
        { name = "buffer" },
      },
    })
    -- `:` cmdline setup.
    cmp.setup.cmdline(":", {
      mapping = cmdline_mappings,
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!", "grep", "grepadd", "vimgrep", "vimgrepadd" },
          },
        },
      }),
    })

    --#endregion
  end,
}
