require('projects').setup()

vim.api.nvim_set_keymap("n", "<leader>pp", ':Projects<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>pa", ':Projects add<CR>', { noremap = true, silent = true })
