return {
  {
    "nvim-java/nvim-java",
    enabled = false,
    config = false,
    dependencies = {
      {
        "JavaHello/spring-boot.nvim",
        commit = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
      },
      {
        "nvim-java/lua-async-await",
      },
      {
        "nvim-java/nvim-java-core",
      },
      {
        "nvim-java/nvim-java-refactor",
      },
      "MunifTanjim/nui.nvim",
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
        "neovim/nvim-lspconfig",
        opts = {
          servers = {
            jdtls = {
              handlers = {
                ["$/progress"] = function() end,
              },
              capabilities = vim.lsp.protocol.make_client_capabilities(),
            },
          },
          setup = {
            jdtls = function()
              require("java").setup({
                jdk = {
                  auto_install = false,
                },
                notifications = {
                  dap = false,
                },
              })

              require("lspconfig").jdtls.setup({})

              -- return true will skip mason-lspconfig from setting up jdtls
              return true
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
