vim.opt.termguicolors = true

vim.api.nvim_set_keymap('n', '<leader>ft', ':Neotree reveal<CR>', { noremap = true, desc = '@: Show file tree' })
vim.api.nvim_set_keymap('n', '<leader>fc', ':Neotree close<CR>', { noremap = true, desc = '@: Close file tree' })
vim.api.nvim_set_keymap('n', '<leader>ff', ':Neotree reveal<CR>', { noremap = true, desc = '@: Focus current file' })
