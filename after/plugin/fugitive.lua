vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.api.nvim_set_keymap('n', '<leader>gb', ':<C-u>call gitblame#echo()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>gc', ':GBranches checkout<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gp', ':G pull<CR>', { noremap = true })
