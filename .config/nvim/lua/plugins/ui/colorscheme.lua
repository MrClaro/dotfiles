-- ======================================
-- ROSE PINE
-- ======================================
-- return {
--   "rose-pine/neovim",
--   name = "rose-pine",
--   config = function()
--     require("rose-pine").setup({
--       variant = "main",
--       dark_variant = "main",
--       highlight_groups = {
--         Normal = { bg = "#000000", fg = "inherit" },
--         ColorColumn = { bg = "#110000" },
--         CursorLine = { bg = "#0a0000" },
--         StatusLine = { bg = "#000000" },
--
--         Statement = { fg = "love", bold = true },
--         ["@keyword"] = { fg = "love", bold = true },
--         ["@function"] = { fg = "love" },
--       },
--     })
--
--     vim.cmd("colorscheme rose-pine")
--   end,
-- }
-- ======================================
-- NIGHTFOX
-- ======================================
-- return {
--   "EdenEast/nightfox.nvim",
--   config = function()
--     require("nightfox").setup({
--       options = {
--         transparent = false,
--         terminal_colors = true,
--         styles = {
--           comments = "italic",
--           keywords = "bold",
--           types = "italic,bold",
--         },
--       },
--       palettes = {
--         carbonfox = {
--           bg1 = "#000000",
--           bg0 = "#000000",
--           sel0 = "#3d0000",
--           comment = "#6e6e6e",
--         },
--       },
--       specs = {
--         carbonfox = {
--           syntax = {
--             keyword = "red",
--             ident = "red_br",
--           },
--         },
--       },
--     })
--
--     vim.cmd("colorscheme carbonfox")
--   end,
-- }

-- ======================================
-- KANAGAWA
-- ======================================
-- require("kanagawa").setup({
--   compile = false,
--   undercurl = true,
--   commentStyle = { italic = true },
--   functionStyle = {},
--   keywordStyle = { italic = true },
--   statementStyle = { bold = true },
--   typeStyle = {},
--   transparent = false,
--   dimInactive = true,
--   terminalColors = true,
--
--   colors = {
--     theme = {
--       all = {
--         ui = {
--           bg_gutter = "none",
--         },
--       },
--     },
--   },
--
--   overrides = function(colors)
--     local theme = colors.theme
--     return {
--       NormalFloat = { bg = theme.ui.bg_p1 },
--       Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
--       PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
--     }
--   end,
--
--   theme = "dragon",
--   background = {
--     dark = "dragon",
--     light = "lotus",
--   },
-- })
--
-- vim.cmd("colorscheme kanagawa-dragon")
--
-- -- ======================================
-- CATPUCCIN
-- ======================================
return {
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,

      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#010101",
          crust = "#020202",
          red = "#ff0000",
          maroon = "#e64553",
        },
      },

      custom_highlights = function(colors)
        return {
          ["@keyword"] = { fg = colors.red, style = { "bold" } },
          ["@keyword.function"] = { fg = colors.red },
          Statement = { fg = colors.red, bold = true },

          ["@function"] = { fg = colors.maroon },
          Function = { fg = colors.maroon },

          CursorLine = { bg = "#0a0a0a" },
          LineNr = { fg = "#444444" },
          CursorLineNr = { fg = colors.red },
        }
      end,

      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        functions = {},
        keywords = { "bold" },
        variables = {},
        numbers = {},
      },

      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
        inlay_hints = { background = true },
      },

      integrations = {
        treesitter = true,
        semantic_tokens = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        cmp = true,
        gitsigns = true,
        mason = true,
        neotree = true,
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        which_key = true,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
