-- luarocks
return {
  -- Install ImageMagick CLI bindings for Lua
  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = {
      rocks = { "magick" },
    },
  },

  -- Render images in Neovim using ImageMagick CLI
  {
    "3rd/image.nvim",
    build = false,
    opts = {
      processor = "magick_cli",
    },
  },
}
