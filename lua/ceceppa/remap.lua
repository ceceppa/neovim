vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = 'directory listing' })

vim.api.nvim_set_keymap('n', '<leader>fs', ':w<CR>', {noremap = true, desc = 'Save file'})
vim.api.nvim_set_keymap('i', '<Tab>', '<C-y>', {noremap = true})

-- Windows
vim.api.nvim_set_keymap('n', '<leader>w=', ':vertical resize 120<CR>', {noremap = true, desc = 'Equalize windows vertical size'})
vim.api.nvim_set_keymap('n', '<C-n>', '<C-w>w', {noremap = true, desc = 'Focus next window'})
vim.api.nvim_set_keymap('n', '<C-p>', '<C-w>W', {noremap = true, desc = 'Focus previous window'})
vim.keymap.set("n", "<C-k>", vim.lsp.buf.format, { desc = 'Format file' })
vim.api.nvim_set_keymap('n', '<leader>wm', ':lua MaximizeCurrentWindow()<CR>', {noremap = true, silent = true})

function MaximizeCurrentWindow()
  -- Store the current window configuration
  local win_config = vim.fn.winsaveview()

  -- Maximize the current window
  vim.cmd('only')

  -- Restore the previous window configuration
  vim.fn.winrestview(win_config)
end

-- Move lines when selected
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })


vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Page down' })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Page up' })
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Other stuff
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "Q", "<nop>")
vim.api.nvim_set_keymap('n', '<leader>qq', ':qa<CR>', {noremap = true, desc = 'Quit'})

vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = 'Make it rain' });

-- Buffers
vim.keymap.set("n", "<leader>bc", ':bdelete<CR>', { desc = 'Close current buffer' })
vim.keymap.set("n", "<leader>bo", ":%bd|e#<CR>", { desc = 'Kill other buffers' })

-- Replace
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })

-- Git
vim.keymap.set('n', '<leader>gw', ':G blame<CR>', { desc = 'Git praise' });
vim.keymap.set('n', '<leader>gw', ':G pull<CR>', { desc = 'Git pull' });
vim.keymap.set('n', '<leader>gd', ':GitGutterDiff<cr>', { desc = 'Git diff' });
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Git status' });


-- Trouble
vim.keymap.set('n', "<leader>pd", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Show all diagnostics errors" });
