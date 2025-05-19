local dap = require("dap")
local mason_registry = require("mason-registry")

-- Caminho base do Mason
local mason_path = vim.fn.stdpath("data") .. "/mason"

-- Configuração do adaptador pwa-node
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = {
      mason_path .. "/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
      "${port}",
    },
  },
}

-- Alias para o adaptador node
dap.adapters["node"] = function(cb, config)
  if config.type == "node" then
    config.type = "pwa-node"
  end
  local nativeAdapter = dap.adapters["pwa-node"]
  if type(nativeAdapter) == "function" then
    nativeAdapter(cb, config)
  else
    cb(nativeAdapter)
  end
end

-- Tipos de arquivos JavaScript/TypeScript
local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

-- Mapeamento de tipos para filetypes
local vscode = require("dap.ext.vscode")
vscode.type_to_filetypes["node"] = js_filetypes
vscode.type_to_filetypes["pwa-node"] = js_filetypes

-- Configurações para cada tipo de arquivo
for _, language in ipairs(js_filetypes) do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
  }
end

-- Configuração para Python
local debugpy_path = mason_path .. "/packages/debugpy/venv"
local python_path = vim.fn.has("win32") == 1 and debugpy_path .. "/Scripts/pythonw.exe" or debugpy_path .. "/bin/python"
require("dap-python").setup(python_path)

-- Configuração para PHP
local php_debug_adapter_path = mason_path .. "/packages/php-debug-adapter/extension/out/phpDebug.js"
dap.adapters.php = {
  type = "executable",
  command = "node",
  args = { php_debug_adapter_path },
}
