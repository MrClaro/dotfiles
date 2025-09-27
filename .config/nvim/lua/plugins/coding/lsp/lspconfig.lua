local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")
local root_patterns = { "angular.json", "nx.json" }
local node_modules_root = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
local project_root = lspconfig.util.root_pattern("angular.json", "nx.json")

if node_modules_root and project_root then
  local tsdkPath = node_modules_root .. "/node_modules/typescript/lib"

  if not configs.analog then
    configs.analog = {
      default_config = {
        cmd = {
          "analog-language-server",
          "--stdio",
        },
        init_options = {
          typescript = {
            tsdk = tsdkPath,
          },
        },
        name = "analog",
        filetypes = {
          "analog",
          "ag",
        },
        root_dir = project_root,
      },
    }
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim" },
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
        "joeveiga/ng.nvim",
      },
      {
        "stevearc/conform.nvim",
        opts = {},
      },
      { "L3MON4D3/LuaSnip" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-path" },
      {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
      },
      { "saadparwaiz1/cmp_luasnip" },
      { "mason-org/mason-lspconfig.nvim" },
      { "onsails/lspkind.nvim" },
      {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      },
      { "rafamadriz/friendly-snippets" },
      { "ray-x/lsp_signature.nvim" },
      { "rcarriga/cmp-dap" },
      {
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        lazy = false, -- This plugin is already lazy
      },
    },
    opts = {
      servers = {
        angularls = {
          root_dir = lspconfig.util.root_pattern("angular.json", "nx.json"),
          filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular", "html.angular" },
          cmd = {
            "node",
            vim.fn.getcwd() .. "/node_modules/@angular/language-server/index.js",
            "--stdio",
          },
        },
        volar = {},
        analog = {},
        tailwindcss = {},
        svelte = {},
        glsl_analyzer = {},
        gopls = {
          keys = {
            { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
          },
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
      setup = {
        html = function(_, opts)
          opts.init_options = {
            dataPaths = {
              vim.fn.getcwd() .. "/node_modules/angular-three/metadata.json",
            },
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = {
              css = true,
              javascript = true,
            },
            provideFormatter = true,
          }

          opts.handlers = {
            ["html/customDataContent"] = function(err, result, ctx, config)
              local function exists(name)
                if type(name) ~= "string" then
                  return false
                end
                return os.execute("test -e " .. name) == 0
              end

              if not vim.tbl_isempty(result) and #result == 1 then
                if not exists(result[1]) then
                  return ""
                end
                local content = vim.fn.join(vim.fn.readfile(result[1]), "\n")
                return content
              end
              return ""
            end,
          }

          return false
        end,
        volar = function(_, opts)
          opts.filetypes = { "vue", "agx" }
        end,
        svelte = function(_, opts) end,
        analog = function(_, opts) end,
        tailwindcss = function(_, opts)
          opts.filetypes = { "css", "scss", "typescript", "analog", "ag", "astro" }
        end,
        marksman = function(_, opts)
          opts.filetypes = { "md", "markdown", "mdx", "agx" }
        end,
        glsl_analyzer = function(_, opts) end,
        angularls = function(_, opts)
          opts.root_dir = lspconfig.util.root_pattern("angular.json", "nx.json")
        end,
        gopls = function(_, opts)
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "gopls" then
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end)
        end,
      },
    },
    config = function()
      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

      lsp_capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

      require("mason").setup({
        registries = {
          "github:mason-org/mason-registry",
        },
      })
      local function get_clangd_cmd()
        local project_path = vim.fn.getcwd()

        local mason_clangd = "clangd"
        local xcode_clangd = "/usr/bin/clangd"

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
              local ra = mason_registry.get_package("rust-analyzer")
              local ra_filename = ra:get_receipt():get().links.bin["rust-analyzer"]
              return { ("%s/%s"):format(ra:get_install_path(), ra_filename or "rust-analyzer") }
            else
              return { "rust-analyzer" }
            end
          end,
        },
      }

      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "bashls",
          "neocmake",
          "lua_ls",
          "marksman",
          "java-debug-adapter",
          "java-test",
          "gdscript",
        },
      })
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          if server_name == "ts_ls" or server_name == "clangd" or require("lspconfig.configs")[server_name] then
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
                runtime = { version = "LuaJIT" },
                workspace = {
                  checkThirdParty = false,
                  library = { vim.env.VIMRUNTIME },
                },
              })
            end,
            settings = { Lua = {} },
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
            vim.lsp.buf.hover({ border = "rounded" })
          end, vim.tbl_extend("force", opts, { desc = "Show hover information" }))
          vim.keymap.set("n", "<leader>vws", function()
            vim.lsp.buf.workspace_symbol()
          end, vim.tbl_extend("force", opts, { desc = "List workspace symbols" }))
          vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, vim.tbl_extend("force", opts, { desc = "Go to next diagnostic" }))
          vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, vim.tbl_extend("force", opts, { desc = "Go to previous diagnostic" }))
          vim.keymap.set("n", "<M-CR>", function()
            vim.lsp.buf.code_action()
          end, vim.tbl_extend("force", opts, { desc = "Show code actions" }))
          vim.keymap.set("n", "<leader>vrr", function()
            vim.lsp.buf.references()
          end, vim.tbl_extend("force", opts, { desc = "Find references" }))
          vim.keymap.set("n", "<leader>vrn", function()
            vim.lsp.buf.rename()
          end, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
          vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
          end, vim.tbl_extend("force", opts, { desc = "Show signature help" }))
          vim.keymap.set("n", "<space>eE", function()
            vim.diagnostic.open_float()
          end, vim.tbl_extend("force", opts, { desc = "Show error on cursor" }))
          vim.keymap.set("n", "<Leader>K", function()
            vim.lsp.buf.signature_help()
          end, vim.tbl_extend("force", opts, { silent = true, noremap = true, desc = "toggle signature" }))
          vim.keymap.set("n", "<leader>f", function()
            require("conform").format()
          end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
        end,
      })

      local signature = require("lsp_signature")
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          signature.on_attach({
            bind = true,
            max_height = 3,
            handler_opts = { border = "rounded" },
            floating_window_off_x = 5,
            floating_window_off_y = function()
              local pumheight = vim.o.pumheight
              local winline = vim.fn.winline()
              local winheight = vim.fn.winheight(0)
              if winline - 1 < pumheight then
                return pumheight
              end
              if winheight - winline < pumheight then
                return -pumheight
              end
              return 0
            end,
          }, bufnr)
        end,
      })

      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb" },
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
          codelldb = function(config)
            config.configurations = {}
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
            kind.menu = "    " .. (strings[2] or "")

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
    end,
  },
}
