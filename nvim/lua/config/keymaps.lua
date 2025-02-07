local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Define the leader
vim.g.mapleader = " "

-- Do things without affecting the registers
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

-- Increment/decrement
keymap.set("n", "+", "<C-a>", opts)
keymap.set("n", "-", "<C-x>", opts)

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d', opts)

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", opts)

-- Save with root permission (descomentado e corrigido)
vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', { desc = "Save file with sudo" })

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)
-- Split window
keymap.set("n", "ss", ":split<CR>", opts)
keymap.set("n", "sv", ":vsplit<CR>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h", opts)
keymap.set("n", "sk", "<C-w>k", opts)
keymap.set("n", "sj", "<C-w>j", opts)
keymap.set("n", "sl", "<C-w>l", opts)

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><", opts)
keymap.set("n", "<C-w><right>", "<C-w>>", opts)
keymap.set("n", "<C-w><up>", "<C-w>+", opts)
keymap.set("n", "<C-w><down>", "<C-w>-", opts)

-- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)
