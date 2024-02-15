-- local mark = require("harpoon.mark")
-- local ui = require("harpoon.ui")
local harpoon = require("harpoon")

harpoon:setup()

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end


vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end, { desc = 'Add file to harpoon' })

vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end, { desc = 'Show harpoon quick menu (Telescope)' })
vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Show harpoon quick menu' })
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(1) end, { desc = 'Open harpoon mark #1' })
vim.keymap.set("n", "<C-g>", function() harpoon:list():select(2) end, { desc = 'Open harpoon mark #1' })
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(3) end, { desc = 'Open harpoon mark #1' })
vim.keymap.set("n", "<C-b>", function() harpoon:list():select(4) end, { desc = 'Open harpoon mark #1' })
