vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sww', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "@ Search current word"
})
vim.keymap.set('v', '<leader>sww', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "@ Search current word"
})
vim.keymap.set('n', '<leader>sf', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "@ Search on current file"
})