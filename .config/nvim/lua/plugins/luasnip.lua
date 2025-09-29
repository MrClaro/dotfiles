return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local ls = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      local ok, custom_angular_snippets = pcall(require, "snippets.angular")

      if ok and type(custom_angular_snippets) == "table" and not vim.tbl_isempty(custom_angular_snippets) then
        ls.add_snippets("htmlangular", custom_angular_snippets)
        vim.notify(
          "Custom Angular snippets loaded successfully! Total:" .. #custom_angular_snippets,
          vim.log.levels.INFO
        )
      else
        if not ok then
          vim.notify(
            "CRITICAL FAILURE: Could not load module 'snippets.angular'. Details:" .. tostring(custom_angular_snippets),
            vim.log.levels.ERROR
          )
        elseif type(custom_angular_snippets) == "table" and vim.tbl_isempty(custom_angular_snippets) then
          vim.notify("WARNING: Module 'snippets.angular' is empty. No snippets loaded.", vim.log.levels.WARN)
        end
      end

      ls.filetype_extend("htmlangular", { "html" })

      ls.config.setup({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      })
    end,
  },
}
