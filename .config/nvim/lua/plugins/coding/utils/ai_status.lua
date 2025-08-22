local M = {}

function M.get_ai_status()
  local icons = {}

  -- Check Supermaven status
  local ok_supermaven, supermaven = pcall(require, "supermaven-nvim.api")
  if ok_supermaven and supermaven.is_running() then
    table.insert(icons, "󰚩 Supermaven")
  end

  -- Check Copilot status
  if vim.fn.exists("*copilot#Enabled") == 1 and vim.fn["copilot#Enabled"]() == 1 then
    table.insert(icons, " Copilot")
  end

  -- Check Avante status
  if package.loaded["avante"] then
    local ok_avante, avante = pcall(require, "avante")
    if ok_avante and avante.is_enabled and avante.is_enabled() then
      table.insert(icons, " Avante")
    end
  end

  -- Return status
  if #icons == 0 then
    return " AI Off"
  end

  return table.concat(icons, " | ")
end

-- Alternative function that shows which AI is currently active based on state
function M.get_current_ai_status()
  -- Try to get current state from the main config
  local current_state = _G.GetCurrentAIState and _G.GetCurrentAIState() or nil

  if current_state == 1 then
    local ok_supermaven, supermaven = pcall(require, "supermaven-nvim.api")
    if ok_supermaven and supermaven.is_running() then
      return "󰚩 Supermaven"
    else
      return " AI Off"
    end
  elseif current_state == 2 then
    if vim.fn.exists("*copilot#Enabled") == 1 and vim.fn["copilot#Enabled"]() == 1 then
      return " Copilot"
    else
      return " AI Off"
    end
  elseif current_state == 3 then
    return " AI Off"
  else
    -- Fallback to original behavior
    return M.get_ai_status()
  end
end

return M
