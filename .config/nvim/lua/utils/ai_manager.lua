local M = {}

G.currentai_state = 2

function M.cycle_ai()
  G.currentai_state = G.currentai_state + 1
  if G.currentai_state > 3 then
    G.currentai_state = 1
  end
  M.switch_to_ai(G.currentai_state)
end

function M.switch_to_ai(state)
  local supermavenapi = require("supermaven-nvim.api")

  supermavenapi.stop()
  if vim.fn.exists(":Copilot") == 2 then
    vim.cmd("Copilot disable")
  end

  G.currentai_state = state

  local status_message = "All AI assistants disabled"
  local status_level = vim.log.levels.INFO

  if state == 1 then
    supermavenapi.start()
    status_message = "Switched to Supermaven"
  elseif state == 2 then
    if vim.fn.exists(":Copilot") == 2 then
      vim.cmd("Copilot enable")
      status_message = "Switched to Copilot"
    else
      status_message = "Copilot command not found"
      status_level = vim.log.levels.ERROR
      G.currentai_state = 3
      M.switch_to_ai(G.currentai_state)
      return
    end
  end

  vim.notify(status_message, status_level, { title = "AI Status" })
end

M.CycleAI = M.cycle_ai
M.SwitchToAI = M.switch_to_ai
M.GetCurrentAIState = function()
  return G.currentai_state
end

return M
