local home = os.getenv("HOME")
local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

return {
  -- Adiciona `nvim-jdtls` como plugin para carregar em arquivos Java
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" }, -- Carrega apenas para arquivos Java
  },

  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "jdtls", -- Adicionado jdtls ao Mason
      })
    end,
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      ---@type lspconfig.options
      servers = {
        cssls = {},
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        tsserver = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          single_file_support = false,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        html = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        lua_ls = {
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              hint = {
                enable = true,
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                },
              },
            },
          },
        },
      },
      setup = {
        -- Configuração do jdtls para arquivos Java
        jdtls = function()
          local status, jdtls = pcall(require, "jdtls")
          if not status then return end

          local config = {
            cmd = {
              "java",
              "-Declipse.application=org.eclipse.jdt.ls.core.id1",
              "-Dosgi.bundles.defaultStartLevel=4",
              "-Declipse.product=org.eclipse.jdt.ls.core.product",
              "-Dlog.protocol=true",
              "-Dlog.level=ALL",
              "-Xmx1g",
              "--add-modules=ALL-SYSTEM",
              "--add-opens",
              "java.base/java.util=ALL-UNNAMED",
              "--add-opens",
              "java.base/java.lang=ALL-UNNAMED",
              "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
              "-jar",
              vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
              "-configuration",
              home .. "/.local/share/nvim/mason/packages/jdtls/config_mac",
              "-data",
              workspace_dir,
            },
            root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
            settings = {
              java = {
                signatureHelp = { enabled = true },
                extendedClientCapabilities = jdtls.extendedClientCapabilities,
                maven = { downloadSources = true },
                referencesCodeLens = { enabled = true },
                references = { includeDecompiledSources = true },
                inlayHints = { parameterNames = { enabled = "all" } },
                format = { enabled = false },
              },
            },
            init_options = { bundles = {} },
          }

          jdtls.start_or_attach(config)
          -- Keymaps específicos para Java
          vim.keymap.set("n", "<leader>co", "<Cmd>lua require'jdtls'.organize_imports()<CR>",
            { desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>crv", "<Cmd>lua require('jdtls').extract_variable()<CR>",
            { desc = "Extract Variable" })
          vim.keymap.set("v", "<leader>crv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
            { desc = "Extract Variable" })
          vim.keymap.set("n", "<leader>crc", "<Cmd>lua require('jdtls').extract_constant()<CR>",
            { desc = "Extract Constant" })
          vim.keymap.set("v", "<leader>crc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
            { desc = "Extract Constant" })
          vim.keymap.set("v", "<leader>crm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
            { desc = "Extract Method" })
        end,
      },
    },
  },
}
