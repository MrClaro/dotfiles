return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "olimorris/neotest-rspec",
      "haydenmeade/neotest-jest",
      "zidhuss/neotest-minitest",
      "mfussenegger/nvim-dap",
      "jfpedroza/neotest-elixir",
      "weilbith/neotest-gradle",
      "nvim-neotest/neotest-go",
    },
    opts = {},
    config = function()
      local neotest = require("neotest")

      local neotest_jest = require("neotest-jest")({
        jestCommand = "npm test --",
      })
      neotest_jest.filter_dir = function(name)
        return name ~= "node_modules" and name ~= "__snapshots__"
      end

      neotest.setup({
        adapters = {
          require("neotest-rspec")({
            rspec_cmd = function()
              return vim.tbl_flatten({
                "bundle",
                "exec",
                "rspec",
              })
            end,
          }),
          neotest_jest,
          require("neotest-minitest"),
          require("neotest-elixir"),
          require("neotest-go"),
        },
        output_panel = {
          enabled = true,
          open = "botright split | resize 15",
        },
        quickfix = {
          open = false,
        },
      })
    end,
  },
  {
    {
      "rcasia/neotest-java",
      ft = "java",
      dependencies = {
        "mfussenegger/nvim-jdtls",
        "mfussenegger/nvim-dap", -- for the debugger
        "rcarriga/nvim-dap-ui", -- recommended
        "theHamsta/nvim-dap-virtual-text", -- recommended
      },
      init = function()
        -- override the default keymaps.
        -- needed until neotest-java is integrated in LazyVim
        local keys = require("lazyvim.plugins.lsp.keymaps").get()
        -- run test file
        keys[#keys + 1] = {
          "<leader>tt",
          function()
            require("neotest").run.run(vim.fn.expand("%"))
          end,
          mode = "n",
        }
        -- run nearest test
        keys[#keys + 1] = {
          "<leader>tr",
          function()
            require("neotest").run.run()
          end,
          mode = "n",
        }
        -- debug test file
        keys[#keys + 1] = {
          "<leader>tD",
          function()
            require("neotest").run.run({ strategy = "dap" })
          end,
          mode = "n",
        }
        -- debug nearest test
        keys[#keys + 1] = {
          "<leader>td",
          function()
            require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
          end,
          mode = "n",
        }
      end,
    },
    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      opts = {
        adapters = {
          ["neotest-java"] = {
            -- config here
          },
        },
      },
    },
  },
}
