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
          -- Automatically determine the path to the Jest config file based on the current file
          jestConfigFile = function()
            local file = vim.fn.expand("%:p")
            if string.find(file, "/packages/") then
              return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
            end
            return vim.fn.getcwd() .. "/jest.config.ts"
          end,
          
          -- Set the current working directory for Jest based on file location
          cwd = function()
            local file = vim.fn.expand("%:p")
            if string.find(file, "/packages/") then
              return string.match(file, "(.-/[^/]+/)src")
            end
            return vim.fn.getcwd()
          end,
        },
      },
      
      -- Show diagnostics as virtual text for neotest
      status = { virtual_text = true },
      
      -- Automatically open the output when running tests
      output = { open_on_run = true },
      
      -- Configure the Quickfix window behavior for test results
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
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")

      -- Configure diagnostic messages format for neotest
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Clean up diagnostic messages by removing unnecessary newlines and tabs
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      -- If Trouble.nvim is available, configure custom behavior for the test results
      if require("lazyvim.util").has("trouble.nvim") then
        opts.consumers = opts.consumers or {}
        opts.consumers.trouble = function(client)
          client.listeners.results = function(adapter_id, results, partial)
            if partial then
              return
            end
            local tree = assert(client:get_position(nil, { adapter = adapter_id }))
            local failed = 0
            for pos_id, result in pairs(results) do
              if result.status == "failed" and tree:get_key(pos_id) then
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

      -- Setup adapters dynamically if configured
      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      -- Initialize Neotest with the specified configuration
      require("neotest").setup(opts)
    end,
    
    -- Keybindings for various Neotest actions
    keys = {
      { ";tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run current file" },
      { ";tr", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { ";tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run all tests in the project" },
      { ";tl", function() require("neotest").run.run_last() end, desc = "Run last test" },
      { ";ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
      { ";to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show test output" },
      { ";tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
      { ";tS", function() require("neotest").run.stop() end, desc = "Stop running tests" },
    },
  },
}
