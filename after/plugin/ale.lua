-- In ~/.config/nvim/after/ftplugin/javascript.lua, or somewhere similar.

-- Fix files with prettier, and then ESLint.
vim.g.ale_fixers = {'prettier', 'eslint'}
vim.g.ale_fix_on_save = 1
vim.g.ale_hover = 1
vim.g.ale_linters_explicit = 1

