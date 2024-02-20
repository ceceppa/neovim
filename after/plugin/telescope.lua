local builtin = require('telescope.builtin')

require("telescope").setup {
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            }
        }
    },
    pickers = {
        current_buffer_tags = { fname_width = 100, },
        jumplist = { fname_width = 100, },
        loclist = { fname_width = 100, },
        lsp_definitions = { fname_width = 100, },
        lsp_document_symbols = { fname_width = 100, },
        lsp_dynamic_workspace_symbols = { fname_width = 100, },
        lsp_implementations = { fname_width = 100, },
        lsp_incoming_calls = { fname_width = 100, },
        lsp_outgoing_calls = { fname_width = 100, },
        lsp_references = { fname_width = 100, },
        lsp_type_definitions = { fname_width = 100, },
        lsp_workspace_symbols = { fname_width = 100, },
        quickfix = { fname_width = 100, },
        tags = { fname_width = 100, },
        git_branches = {
            mappings = {
                i = { ["<cr>"] = builtin.git_switch_branch },
            },
        },
        live_grep = {
            file_ignore_patterns = { 'node_modules', '.git', '.venv' },
            additional_args = function(_)
                return { "--hidden" }
            end
        },
        find_files = {
            file_ignore_patterns = { 'node_modules', '.git', '.venv' },
            hidden = true
        }
    },
}
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")
require("telescope").load_extension("notify")

-- Project
vim.keymap.set('n', '<leader>pf', ':Telescope find_files hidden=true<CR>', { desc = '@: Find files' })
vim.keymap.set('n', '<C-S-p>', ':Telescope find_files hidden=true<CR>', { desc = '@: Find files' })
vim.keymap.set('n', '<leader>pg', builtin.git_files, { desc = '@: Search in git files' })

vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = '@: Show buffers' })
vim.keymap.set('n', '<leader>e', ':Telescope diagnostics<CR>', { desc = '@: Show errors in all open buffers' });
vim.keymap.set('n', '<leader>ds', ':Telescope lsp_document_symbols<CR>', { desc = '@: Document symbols' });
-- vim.keymap.set('n', '<leader>m', ':Telescope marks<CR>', { desc = '@: Show all marks' });

vim.keymap.set('n', 'zz', ':Telescope spell_suggest<CR>', { desc = '@: Spell suggest' });
vim.keymap.set('n', '<leader>?', ':Telescope keymaps<CR>', { desc = '@: Keymaps' });
vim.keymap.set('i', '<C-r><C-r>', '<C-o>:Telescope registers<CR>', { desc = '@: Registers' });

-- Search
local old_search

vim.keymap.set('n', '<leader>sp', function()
    old_search = vim.fn.input("Grep in all files > ")
    builtin.grep_string({ search = old_search });
end, { desc = '@: Grep in all files' })

vim.keymap.set('n', '<leader>sa', function()
    builtin.grep_string({ search = old_search });
end, { desc = '@: Repeat last grep in all files search' })

vim.keymap.set('n', '<leader>sw', ':Telescope grep_string<CR>', { desc = '@: Search word under cursor' });
vim.keymap.set('n', '<leader>sl', ':Telescope live_grep<CR>', { desc = '@: Live grep in all files' });
vim.keymap.set('n', '<leader>sr', ':Telescope lsp_references<CR>', { desc = '@: Search reference (Find usage)' });
vim.keymap.set('n', '<leader>sh', ':Telescope search_history<CR>', { desc = '@: Search history' });
