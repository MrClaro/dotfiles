return {
  {
    "nvim-java/nvim-java",
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      {
        "williamboman/mason.nvim",
        opts = {
          registries = {
            "github:nvim-java/mason-registry",
            "github:mason-org/mason-registry",
          },
        },
      },
      {
        "williamboman/mason-lspconfig.nvim",
        opts = {
          ensure_installed = { "jdtls" },
          handlers = {
            ["jdtls"] = function()
              local mason_registry = vim.fn.stdpath("data") .. "/mason"
              local bundles = {}

              -- Java Test Bundle
              local java_test_path = "/home/adrdev/.local/share/vscode-java-test"
              local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/server/*.jar"), "\n")
              if java_test_bundle[1] ~= "" then
                vim.list_extend(bundles, java_test_bundle)
              else
                vim.notify("⚠️ No JARs found for java-test.", vim.log.levels.WARN)
              end

              -- Java Debug Bundle
              local java_debug_path = "/home/adrdev/.local/share/java-debug"
              local java_debug_bundle = vim.split(
                vim.fn.glob(
                  java_debug_path .. "/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
                ),
                "\n"
              )
              if java_debug_bundle[1] ~= "" then
                vim.list_extend(bundles, java_debug_bundle)
              else
                vim.notify("⚠️ No JARs found for java-debug.", vim.log.levels.WARN)
              end

              require("java").setup({
                root_markers = {
                  "settings.gradle",
                  "settings.gradle.kts",
                  "pom.xml",
                  "build.gradle",
                  "mvnw",
                  "gradlew",
                  ".git",
                },

                jdtls = {
                  version = "v1.43.0",
                  config = {
                    bundles = bundles,
                    settings = {
                      java = {
                        inlayHints = {
                          parameterNames = {
                            enabled = "all",
                          },
                          parameterTypes = {
                            enabled = true,
                          },
                          variableTypes = {
                            enabled = true,
                          },
                          lambdaParameterTypes = {
                            enabled = true,
                          },
                        },
                      },
                    },
                  },
                },
                lombok = { version = "nightly" },
                java_test = {
                  enable = true,
                  version = "0.43.1",
                },
                java_debug_adapter = {
                  enable = true,
                  version = "0.53.2",
                },
                spring_boot_tools = {
                  enable = true,
                  version = "1.55.1",
                },
                jdk = {
                  auto_install = true,
                  version = "21.0.7",
                },
                notifications = { dap = true },
                verification = {
                  invalid_order = true,
                  duplicate_setup_calls = true,
                  invalid_mason_registry = false,
                },
                mason = {
                  registries = {
                    "github:nvim-java/mason-registry",
                  },
                },
                dap = {
                  enabled = java_debug_bundle[1] ~= "",
                  debug_adapter_path = java_debug_bundle[1],
                },
                test = {
                  enabled = java_test_bundle[1] ~= "",
                  test_server_path = java_test_path .. "/extension/server",
                },
              })

              require("jdtls.dap").setup_dap_main_class_configs()

              -- Manual adapter registration for nvim-dap
              if java_debug_bundle[1] ~= "" then
                local dap = require("dap")
                dap.adapters["java"] = {
                  type = "server",
                  host = "127.0.0.1",
                  port = 5005,
                }
              end
            end,
          },
        },
      },
    },
  },

  -- Java dependencies helper
  {
    "JavaHello/java-deps.nvim",
    ft = "java",
    dependencies = "mfussenegger/nvim-jdtls",
    config = function()
      require("java-deps").setup({})
    end,
  },

  -- Maven integration
  {
    "eatgrass/maven.nvim",
    cmd = { "Maven", "MavenExec" },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("maven").setup({
        executable = "/usr/bin/mvn",
        test_adapter = "junit",
      })
    end,
  },

  -- Treesitter support for Java
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "java" })
      end
    end,
  },
}
