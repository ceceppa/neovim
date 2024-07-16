local harpoon = require("harpoon")

harpoon:setup({
    settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
    },
})

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = '@: Add file to harpoon' })

vim.keymap.set("n", "<C-t>", function() harpoon:list():select(1) end, { desc = '@: Open harpoon mark #1' })
vim.keymap.set("n", "<C-g>", function() harpoon:list():select(2) end, { desc = '@: Open harpoon mark #1' })
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(3) end, { desc = '@: Open harpoon mark #1' })
vim.keymap.set("n", "<C-b>", function() harpoon:list():select(4) end, { desc = '@: Open harpoon mark #1' })
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
