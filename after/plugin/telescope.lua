local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>bb', builtin.buffers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>sp', function()
	builtin.grep_string({ search = vim.fn.input("Grep in all files > ") });
end)
vim.keymap.set('n', '<leader>sw', ':Telescope grep_string<CR>');
vim.keymap.set('n', '<leader>fu', ':Telescope lsp_references<CR>');
