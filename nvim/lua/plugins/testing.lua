return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-plenary",
    },
    opts = {
      -- Define the adapters for different testing frameworks
      adapters = {
        -- Adapter for Plenary (generic test framework)
        ["neotest-plenary"] = {},

        -- Adapter for Jest tests with dynamic configuration based on the project structure
        ["neotest-jest"] = {
          -- Function to dynamically get Jest config file
          jestConfigFile = function()
            local file = vim.fn.expand("%:p")
            if file:find("/packages/") then
              return file:match("(.-/[^/]+/)src") .. "jest.config.ts"
            end
            return vim.fn.getcwd() .. "/jest.config.ts"
          end,

          -- Set Jest's current working directory dynamically
          cwd = function()
            local file = vim.fn.expand("%:p")
            return file:find("/packages/") and file:match("(.-/[^/]+/)src") or vim.fn.getcwd()
          end,
        },
      },

      -- Enable virtual text diagnostics for test status
      status = { virtual_text = true },

      -- Automatically open the output after running tests
      output = { open_on_run = true },

      -- Configure Quickfix window behavior for test results
      quickfix = {
        open = function()
          if require("lazyvim.util").has("trouble.nvim") then
            require("trouble").open({ mode = "quickfix", focus = false })
          else
            vim.cmd("copen")
          end
        end,
      },
    },

    -- Function to configure Neotest with specific options
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")

      -- Configure virtual text format for cleaner diagnostic messages
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            return diagnostic.message:gsub("[\n\t%s]+", " "):gsub("^%s+", "")
          end,
        },
      }, neotest_ns)

      -- Integrate with Trouble.nvim if available
      if require("lazyvim.util").has("trouble.nvim") then
        opts.consumers = opts.consumers or {}
        opts.consumers.trouble = function(client)
          client.listeners.results = function(adapter_id, results, partial)
            if partial then
              return
            end
            local tree = assert(client:get_position(nil, { adapter = adapter_id }))
            local failed = 0
            for _, result in pairs(results) do
              if result.status == "failed" then
                failed = failed + 1
              end
            end
            vim.schedule(function()
              local trouble = require("trouble")
              if trouble.is_open() then
                trouble.refresh()
                if failed == 0 then
                  trouble.close()
                end
              end
            end)
          end
        end
      end

      -- Setup adapters dynamically
      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters) do
          local adapter = require(name)
          if config and type(config) == "table" then
            if adapter.setup then
              adapter.setup(config)
            else
              adapter(config)
            end
          end
          adapters[#adapters + 1] = adapter
        end
        opts.adapters = adapters
      end

      -- Initialize Neotest
      require("neotest").setup(opts)
    end,

    -- Keybindings for Neotest actions
    keys = {
      {
        ";tt",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run current file",
      },
      {
        ";tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run nearest test",
      },
      {
        ";tT",
        function()
          require("neotest").run.run(vim.loop.cwd())
        end,
        desc = "Run all tests in the project",
      },
      {
        ";tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run last test",
      },
      {
        ";ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle test summary",
      },
      {
        ";to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show test output",
      },
      {
        ";tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle output panel",
      },
      {
        ";tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop running tests",
      },
    },
  },
}
