vim.opt.nu = true
vim.opt.relativenumber = true
vim.o.mouse = "a" -- always enable mouse mode

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.o.guifont = "VictorMono Nerd Font:h16"

vim.o.ignorecase = true -- ignore case when searching
vim.o.smartcase = true -- Unless we explicitly use cases in search

-- Set up automatic spell checking
vim.opt.spelllang = "en"
vim.opt.spell = true
