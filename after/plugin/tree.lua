-- disable netrw at the very start of your init.lua (strongly advised)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 60,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
})

vim.api.nvim_set_keymap('n', '<leader>ft', ':NvimTreeFindFile<CR>', { noremap = true, desc = 'Show file tree' })
vim.api.nvim_set_keymap('n', '<leader>fc', ':NvimTreeClose<CR>', { noremap = true, desc = 'Close file tree' })
