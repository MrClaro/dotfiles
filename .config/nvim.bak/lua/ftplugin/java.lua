-- JDTLS (Java LSP) configuration
local home = vim.env.HOME -- Get the home directory
local jdtls = require("jdtls")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/jdtls-workspace/" .. project_name
local system_os = "linux" -- Explicitly set for Arch Linux in WSL

-- Debug function to log messages
local function debug_log(message)
  print("[JDTLS DEBUG] " .. message)
end

-- Check if the JDTLS launcher exists
local jdtls_launcher =
  vim.fn.glob(home .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
if jdtls_launcher == "" then
  vim.notify("JDTLS launcher not found!", vim.log.levels.ERROR)
  return
end

-- Needed for debugging
local bundles = {
  vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
}

-- Needed for running/debugging unit tests
vim.list_extend(
  bundles,
  vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", true) or "", "\n")
)

-- Validate bundles
if #bundles == 0 then
  vim.notify("No bundles found for debugging and testing!", vim.log.levels.WARN)
end

-- JDTLS configuration
local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. home .. "/.local/share/nvim/mason/share/jdtls/lombok.jar",
    "-Xmx4g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    jdtls_launcher,
    "-configuration",
    home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. system_os,
    "-data",
    workspace_dir,
  },

  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "pom.xml", "build.gradle" }),

  settings = {
    java = {
      home = "/usr/lib/jvm/java-23-openjdk",
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          { name = "JavaSE-11", path = "/usr/lib/jvm/java-11-openjdk" },
          { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk" },
          { name = "JavaSE-19", path = "/usr/lib/jvm/java-19-openjdk" },
          { name = "JavaSE-23", path = "/usr/lib/jvm/java-23-openjdk" },
        },
      },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      signatureHelp = { enabled = true },
      format = { enabled = true },
    },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
      importOrder = { "java", "javax", "com", "org" },
    },
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },

  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  flags = { allow_incremental_sync = true },
  init_options = { bundles = bundles },
}

-- Attach JDTLS to a valid buffer
config["on_attach"] = function(client, bufnr)
  -- Validate buffer
  if not vim.api.nvim_buf_is_valid(bufnr) then
    debug_log("Invalid buffer ID: " .. bufnr)
    return
  end

  debug_log("Attaching to buffer: " .. bufnr)
  debug_log("Buffer name: " .. vim.api.nvim_buf_get_name(bufnr))

  -- Configure DAP for debugging
  if client.name == "jdtls" then
    jdtls.setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()
  end
end

-- Start or attach JDTLS
jdtls.start_or_attach(config)
