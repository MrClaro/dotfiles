-- Keymaps configuration
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Leader key (already set in options, but keeping for clarity)
vim.g.mapleader = " "

-- Navigation and scrolling
keymap.set("n", "<C-d>", "<C-d>zz", opts) -- Scroll down and center
keymap.set("n", "<C-u>", "<C-u>zz", opts) -- Scroll up and center

-- Exit insert mode
keymap.set("i", "jk", "<ESC>", opts)
keymap.set("i", "jj", "<ESC>", opts)

-- Register-preserving operations
-- Delete without affecting registers
keymap.set("n", "x", '"_x', opts)

-- Paste from yank register (register 0)
keymap.set("n", "<Leader>p", '"0p', opts)
keymap.set("n", "<Leader>P", '"0P', opts)
keymap.set("v", "<Leader>p", '"0p', opts)

-- Change without affecting registers
keymap.set("n", "<Leader>c", '"_c', opts)
keymap.set("n", "<Leader>C", '"_C', opts)
keymap.set("v", "<Leader>c", '"_c', opts)
keymap.set("v", "<Leader>C", '"_C', opts)

-- Delete without affecting registers
keymap.set("n", "<Leader>d", '"_d', opts)
keymap.set("n", "<Leader>D", '"_D', opts)
keymap.set("v", "<Leader>d", '"_d', opts)
keymap.set("v", "<Leader>D", '"_D', opts)

-- Increment/decrement numbers
keymap.set("n", "+", "<C-a>", opts)
keymap.set("n", "-", "<C-x>", opts)

-- Text selection
keymap.set("n", "<C-a>", "gg<S-v>G", opts) -- Select all

-- Line creation without continuation
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts) -- New line below
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts) -- New line above

-- Jumplist navigation
keymap.set("n", "<C-m>", "<C-i>", opts)

-- Window management
-- Split windows
keymap.set("n", "ss", ":split<CR>", opts) -- Horizontal split
keymap.set("n", "sv", ":vsplit<CR>", opts) -- Vertical split

-- Move between windows
keymap.set("n", "sh", "<C-w>h", opts) -- Move to left window
keymap.set("n", "sk", "<C-w>k", opts) -- Move to upper window
keymap.set("n", "sj", "<C-w>j", opts) -- Move to lower window
keymap.set("n", "sl", "<C-w>l", opts) -- Move to right window

-- Resize windows
keymap.set("n", "<C-w><left>", "<C-w><", opts) -- Decrease width
keymap.set("n", "<C-w><right>", "<C-w>>", opts) -- Increase width
keymap.set("n", "<C-w><up>", "<C-w>+", opts) -- Increase height
keymap.set("n", "<C-w><down>", "<C-w>-", opts) -- Decrease height

-- LSP diagnostics (set after LSP loads)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspDiagnostics", {}),
  callback = function()
    vim.keymap.set("n", "<C-j>", function()
      vim.diagnostic.goto_next()
    end, { buffer = true, desc = "Next diagnostic" })
  end,
})

-- LazyGit integration
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("UserLazyGit", {}),
  callback = function()
    -- Remove any conflicting keybind
    pcall(vim.keymap.del, "n", "<leader>l")
    -- Set LazyGit keybind
    vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })
  end,
})

-- Commented out keymaps (preserved for reference)
-- Tab indentation in insert mode
-- keymap.set("i", "<Tab>", "<C-t>")
-- keymap.set("i", "<S-Tab>", "<C-d>")

-- Delete word backwards
-- keymap.set("n", "dw", 'vb"_d', opts)
