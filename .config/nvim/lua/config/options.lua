-- Leader key
vim.g.mapleader = " "

-- Encoding settings
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- UI settings
vim.opt.number = true
vim.opt.title = true
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.scrolloff = 10

-- Search settings
vim.opt.hlsearch = true
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.inccommand = "split"

-- Indentation and tabs
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smarttab = true
vim.opt.breakindent = true

-- Text wrapping
vim.opt.wrap = false -- No wrap lines
vim.opt.backspace = { "start", "eol", "indent" }

-- Backup settings
vim.opt.backup = false
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }

-- Window splitting
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitkeep = "cursor"

-- File searching
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })

-- Format options
vim.opt.formatoptions:append({ "r" }) -- Add asterisks in block comments

-- Shell (commented out)
-- vim.opt.shell = "fish"
-- vim.opt.mouse = ""

-- Terminal settings for undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- File type associations
vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])

-- Neovim 0.8+ specific settings
if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.cmdheight = 0
end
