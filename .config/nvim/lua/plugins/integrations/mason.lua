return {
  "mason-org/mason.nvim",
  opts = {
    version = "v2.0.0",
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
    ensure_installed = {
      "jdtls",
    },
  },
}
