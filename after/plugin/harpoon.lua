local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file, { desc = 'Add file to harpoon' })
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = 'Show harpoon quick menu' })
vim.keymap.set("n", "<C-t>", ':lua require("harpoon.ui").nav_file(1)<CR>', { desc = 'Open harpoon mark #1' })
vim.keymap.set("n", "<C-g>", ':lua require("harpoon.ui").nav_file(2)<CR>', { desc = 'Open harpoon mark #1' })
vim.keymap.set("n", "<C-h>", ':lua require("harpoon.ui").nav_file(3)<CR>', { desc = 'Open harpoon mark #1' })
vim.keymap.set("n", "<C-h>", ':lua require("harpoon.ui").nav_file(4)<CR>', { desc = 'Open harpoon mark #1' })
