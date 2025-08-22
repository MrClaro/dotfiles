-- Verifica se é um arquivo Java antes de iniciar o JDTLS
if vim.bo.filetype ~= "java" then
  return
end

local home = os.getenv("HOME")
local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

local status, jdtls = pcall(require, "jdtls")
if not status then
  return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
    "-jar",
    vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    home .. "/.local/share/nvim/mason/packages/jdtls/config_mac",
    "-data",
    workspace_dir,
  },
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
  settings = {
    java = {
      signatureHelp = { enabled = true },
      extendedClientCapabilities = extendedClientCapabilities,
      maven = {
        downloadSources = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all", -- literals, all, none
        },
      },
      format = {
        enabled = false,
      },
    },
  },
  init_options = {
    extendedClientCapabilities = extendedClientCapabilities,
  },
}

require("jdtls").start_or_attach(config)

-- Keymaps específicos para Java
vim.keymap.set("n", "<leader>co", "<Cmd>lua require'jdtls'.organize_imports()<CR>", {
  desc = "Organize Imports",
  buffer = true,
})
vim.keymap.set("n", "<leader>crv", "<Cmd>lua require('jdtls').extract_variable()<CR>", {
  desc = "Extract Variable",
  buffer = true,
})
vim.keymap.set("v", "<leader>crv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", {
  desc = "Extract Variable",
  buffer = true,
})
vim.keymap.set("n", "<leader>crc", "<Cmd>lua require('jdtls').extract_constant()<CR>", {
  desc = "Extract Constant",
  buffer = true,
})
vim.keymap.set("v", "<leader>crc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", {
  desc = "Extract Constant",
  buffer = true,
})
vim.keymap.set("v", "<leader>crm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", {
  desc = "Extract Method",
  buffer = true,
})

-- Autocmds específicos para o buffer atual (Java)
local augroup = vim.api.nvim_create_augroup("JdtlsInlayHints", { clear = true })

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  group = augroup,
  buffer = 0,
  callback = function()
    vim.lsp.buf.inlay_hint(0, true)
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  group = augroup,
  buffer = 0,
  callback = function()
    vim.lsp.buf.inlay_hint(0, false)
  end,
})
