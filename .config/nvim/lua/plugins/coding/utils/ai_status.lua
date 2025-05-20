local M = {}

function M.get_ai_status()
  local icons = {}
  local ok_supermaven, supermaven = pcall(require, "supermaven-nvim.api")
  if ok_supermaven and supermaven.is_running() then
    table.insert(icons, "󰚩 Supermaven")
  end

  if vim.fn.exists("*copilot#Enabled") == 1 and vim.fn["copilot#Enabled"]() == 1 then
    table.insert(icons, " Copilot")
  end

  if package.loaded["avante"] then
    local is_enabled = require("avante").is_enabled and require("avante").is_enabled()
    if is_enabled then
      table.insert(icons, " Avante")
    end
  end

  if #icons == 0 then
    return " AI Off"
  end

  return table.concat(icons, " | ")
end

return M
