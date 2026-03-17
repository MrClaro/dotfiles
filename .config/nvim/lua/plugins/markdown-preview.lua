return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = "cd app && npm install",
  keys = {
    { "<leader>cp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown Preview" },
  },
}
