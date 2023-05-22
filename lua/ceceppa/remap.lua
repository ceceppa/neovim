vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.api.nvim_set_keymap('n', '<leader>D', ':t.<CR>', {noremap = true})
vim.api.nvim_set_keymap('v', '<leader>D', ':t.<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>qq', ':qa<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>gb', ':<C-u>call gitblame#echo()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ss', ':w<CR>', {noremap = true})
vim.api.nvim_set_keymap('i', '<Tab>', '<C-y>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>gc', ':GBranches checkout<CR>', { noremap = true })

-- Windows
vim.api.nvim_set_keymap('n', '<leader>wv', '<C-w>v', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>wl', '<C-w>l', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>1', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>2', '<C-w>l', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>wh', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>wk', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>wj', '<C-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>w=', ':vertical resize 120<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>wm', ':lua MaximizeCurrentWindow()<CR>', {noremap = true, silent = true})

function MaximizeCurrentWindow()
  -- Store the current window configuration
  local win_config = vim.fn.winsaveview()

  -- Maximize the current window
  vim.cmd('only')

  -- Restore the previous window configuration
  vim.fn.winrestview(win_config)
end

-- Buffers
vim.api.nvim_set_keymap('n', '<leader>bp', '<C-^>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>bn', ':bnext<CR>', {noremap = true})

-- Move lines when selected
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)


