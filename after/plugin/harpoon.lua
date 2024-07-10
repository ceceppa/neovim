local harpoon = require("harpoon")
local actions = require "telescope.actions"

harpoon:setup({
    settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
    },
})

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
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<C-x>", function()
                actions.close(prompt_bufnr)

                harpoon_files:remove_at(
                    require("telescope.actions.state").get_selected_entry(prompt_bufnr).index
                )
            end)

            return true
        end,
    }):find()
end

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = '@: Add file to harpoon' })

vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = '@: Show harpoon quick menu (Telescope)' })
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(1) end, { desc = '@: Open harpoon mark #1' })
vim.keymap.set("n", "<C-g>", function() harpoon:list():select(2) end, { desc = '@: Open harpoon mark #1' })
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(3) end, { desc = '@: Open harpoon mark #1' })
vim.keymap.set("n", "<C-b>", function() harpoon:list():select(4) end, { desc = '@: Open harpoon mark #1' })
