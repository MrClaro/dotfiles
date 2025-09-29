local M = {}

-- Configuration options
local config = {
  -- Output directory options:
  -- "same" - same directory as SCSS file
  -- "css" - creates/uses a 'css' subdirectory
  -- "custom" - uses custom_output_dir
  output_mode = "same",
  custom_output_dir = "./dist/css/",

  -- Sass compilation options
  style = "compressed", -- "expanded", "compressed"
  source_map = false,

  -- Notification settings
  notify_success = true,
  notify_error = true,
}

-- Get output file path based on configuration
local function get_output_path(input_file)
  local file_dir = vim.fn.expand("%:p:h")
  local file_name = vim.fn.expand("%:t:r")

  if config.output_mode == "same" then
    return file_dir .. "/" .. file_name .. ".css"
  elseif config.output_mode == "css" then
    local css_dir = file_dir .. "/css"
    vim.fn.mkdir(css_dir, "p") -- Create directory if it doesn't exist
    return css_dir .. "/" .. file_name .. ".css"
  elseif config.output_mode == "custom" then
    vim.fn.mkdir(config.custom_output_dir, "p")
    return config.custom_output_dir .. "/" .. file_name .. ".css"
  end
end

-- Main compilation function
function M.compile_scss()
  local input_file = vim.fn.expand("%:p")
  local output_file = get_output_path(input_file)
  local file_name = vim.fn.expand("%:t:r")

  -- Check if sass is available
  if vim.fn.executable("sass") ~= 1 then
    if config.notify_error then
      vim.notify("⚠ Sass CLI not found. Install with: npm install -g sass", vim.log.levels.WARN)
    end
    return
  end

  -- Build sass command
  local cmd_parts = {
    "sass",
    "--style=" .. config.style,
  }

  if not config.source_map then
    table.insert(cmd_parts, "--no-source-map")
  end

  table.insert(cmd_parts, '"' .. input_file .. '"')
  table.insert(cmd_parts, '"' .. output_file .. '"')

  local cmd = table.concat(cmd_parts, " ")

  -- Execute compilation
  local result = vim.fn.system(cmd)

  if vim.v.shell_error == 0 then
    if config.notify_success then
      local output_name = vim.fn.fnamemodify(output_file, ":t")
      local relative_path = vim.fn.fnamemodify(output_file, ":.")
      print("✅ " .. file_name .. ".scss → " .. relative_path)
    end
  else
    if config.notify_error then
      vim.notify("❌ SCSS Compilation Error:\n" .. result, vim.log.levels.ERROR)
    end
  end
end

-- Watch mode toggle (experimental)
local watch_job = nil

function M.toggle_watch()
  if watch_job then
    vim.fn.jobstop(watch_job)
    watch_job = nil
    print("🛑 SCSS watch mode stopped")
  else
    local current_dir = vim.fn.expand("%:p:h")
    watch_job = vim.fn.jobstart({
      "sass",
      "--watch",
      current_dir .. ":" .. current_dir,
      "--style=" .. config.style,
    }, {
      on_stdout = function(_, data)
        if data and #data > 0 then
          for _, line in ipairs(data) do
            if line ~= "" then
              print(" " .. line)
            end
          end
        end
      end,
      on_stderr = function(_, data)
        if data and #data > 0 then
          vim.notify("SCSS Watch Error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
        end
      end,
    })
    print("SCSS watch mode started for: " .. current_dir)
  end
end

-- Setup function to configure options
function M.setup(opts)
  if opts then
    config = vim.tbl_deep_extend("force", config, opts)
  end

  -- Create autocmd for auto-compilation
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.scss", "*.sass" },
    callback = M.compile_scss,
    desc = "Auto-compile SCSS/Sass to CSS",
    group = vim.api.nvim_create_augroup("ScssAutoCompile", { clear = true }),
  })

  -- Create user commands
  vim.api.nvim_create_user_command("ScssCompile", M.compile_scss, {
    desc = "Manually compile current SCSS file",
  })

  vim.api.nvim_create_user_command("ScssWatch", M.toggle_watch, {
    desc = "Toggle SCSS watch mode for current directory",
  })

  -- Optional keymaps (uncomment if you want them)
  -- vim.keymap.set("n", "<leader>cs", M.compile_scss, { desc = "Compile SCSS to CSS" })
  -- vim.keymap.set("n", "<leader>cw", M.toggle_watch, { desc = "Toggle SCSS Watch Mode" })
end

return M
