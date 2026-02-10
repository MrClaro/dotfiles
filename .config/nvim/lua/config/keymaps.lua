-- Keymaps configuration
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "

-- =============================================================================
-- 1. Navigation Enhancements
-- ============================================================================
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Maintain cursor position when navigating paragraphs and search results
keymap.set("n", "{", "{zz", opts)
keymap.set("n", "}", "}zz", opts)
keymap.set("n", "n", "nzz", opts)
keymap.set("n", "N", "Nzz", opts)

-- Exit insert mode
keymap.set("i", "jk", "<ESC>", opts)
keymap.set("i", "jj", "<ESC>", opts)

-- =============================================================================
-- 2. YANK, DELETE, AND PASTE IMPROVEMENTS
-- ============================================================================
keymap.set("n", "x", '"_x', opts)
keymap.set("n", "<Leader>p", '"0p', opts)
keymap.set("n", "<Leader>P", '"0P', opts)
keymap.set("v", "<Leader>p", '"0p', opts)
keymap.set("n", "<Leader>c", '"_c', opts)
keymap.set("n", "<Leader>C", '"_C', opts)
keymap.set("v", "<Leader>c", '"_c', opts)
keymap.set("v", "<Leader>C", '"_C', opts)
keymap.set("n", "<Leader>d", '"_d', opts)
keymap.set("n", "<Leader>D", '"_D', opts)
keymap.set("v", "<Leader>d", '"_d', opts)
keymap.set("v", "<Leader>D", '"_D', opts)

-- Save commands
keymap.set("n", "<C-s>", "<cmd>w<CR>", opts)
keymap.set("n", "<leader>sn", "<cmd>noautocmd w <cr>", { desc = "Save without formatting" })

-- Increment/decrement numbers
keymap.set("n", "+", "<C-a>", opts)
keymap.set("n", "-", "<C-x>", opts)

-- Text selection
keymap.set("n", "<C-a>", "gg<S-v>G", opts) -- Select all

-- Line creation
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Toggle line wrap
keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", { desc = "Toggle line wrap" })

-- =============================================================================
-- 3. WINDOW & BUFFER MANAGEMENT
-- =============================================================================s

-- Split windows
keymap.set("n", "ss", ":split<CR>", opts)
keymap.set("n", "sv", ":vsplit<CR>", opts)

-- Navigation between windows using 's' + direction
keymap.set("n", "sh", "<C-w>h", opts)
keymap.set("n", "sk", "<C-w>k", opts)
keymap.set("n", "sj", "<C-w>j", opts)
keymap.set("n", "sl", "<C-w>l", opts)

-- Navigation between windows using Ctrl + direction
-- Nota: <C-j> its already used for jumping to next diagnostic
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Resize windows using arrow keys
keymap.set("n", "<up>", "<cmd>resize -2<CR>", opts)
keymap.set("n", "<down>", "<cmd>resize +2<CR>", opts)
keymap.set("n", "<left>", "<cmd>vertical resize -2<CR>", opts)
keymap.set("n", "<right>", "<cmd>vertical resize +2<CR>", opts)

-- Buffer navigation
keymap.set("n", "<tab>", "<cmd>bnext<CR>", opts)
keymap.set("n", "<s-tab>", "<cmd>bprevious<CR>", opts)
keymap.set("n", "<leader>x", "<cmd>bp<bar>bd #<CR>", { desc = "Close buffer" })
keymap.set("n", "<leader>b", "<cmd>enew<CR>", { desc = "New buffer" })

-- =============================================================================
-- 4. VISUAL MODE IMPROVEMENTS
-- =============================================================================

-- Stay in indent mode
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- Move selected lines up and down
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Paste without overwriting clipboard
keymap.set("v", "p", '"_dp', opts)

-- =============================================================================
-- 5. AUTOCMDS & PLUGINS
-- =============================================================================

-- LSP diagnostics
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspDiagnostics", {}),
  callback = function()
    -- <C-j> is already used for window navigation
    vim.keymap.set("n", "<C-j>", function()
      vim.diagnostic.goto_next()
    end, { buffer = true, desc = "Next diagnostic" })
  end,
})

-- LazyGit
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("UserLazyGit", {}),
  callback = function()
    pcall(vim.keymap.del, "n", "<leader>l")
    vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })
  end,
})

-- Markview
-- keymap.set("n", "<leader>mv", "<cmd>Markview toggle<cr>", { desc = "Toggle Markview" })
