local builtin = require('telescope.builtin')

local h_pct = 0.90
local w_pct = 0.90

local fullscreen_setup = {
    borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
    color_devicons = true,
    layout_strategy = 'flex',
    layout_config = {
        flex = { flip_columns = 100 },
        horizontal = {
            mirror = false,
            prompt_position = 'bottom',
            width = function(a, cols, b)
                return math.floor(cols * w_pct)
            end,
            height = function(_, _, rows)
                return math.floor(rows * h_pct)
            end,
            preview_cutoff = 10,
            preview_width = 0.5,
        },
        vertical = {
            mirror = true,
            prompt_position = 'top',
            width = function(_, cols, _)
                return math.floor(cols * w_pct)
            end,
            height = function(_, _, rows)
                return math.floor(rows * h_pct)
            end,
            preview_cutoff = 10,
            preview_height = 0.5,
        },
    },
}

require("telescope").setup {
    defaults = vim.tbl_extend('error', fullscreen_setup, {
        path_display = { "filename_first" },
        mappings = {
            n = {
                ['o'] = require('telescope.actions.layout').toggle_preview,
                ['<C-c>'] = require('telescope.actions').close,
            },
            i = {
                ['<C-o>'] = require('telescope.actions.layout').toggle_preview,
            },
        },
    }),
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
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
            file_ignore_patterns = { 'node_modules', '^.git/', '.venv' },
            additional_args = function(_)
                return { "--hidden" }
            end
        },
        find_files = {
            file_ignore_patterns = { 'node_modules', '^.git/', '.venv' },
            find_command = { 'rg', '--files', '--hidden' },
            hidden = true
        }
    },
}
require("telescope").load_extension("ui-select")
require("telescope").load_extension("notify")

-- Project
vim.keymap.set('n', '<leader>pf', ':Telescope find_files hidden=true<CR>', { desc = '@: Find files' })
vim.keymap.set('n', '<C-p>', function() builtin.find_files({ hidden = true }) end, { desc = '@: Find files' })
vim.keymap.set('n', '<leader>pg', builtin.git_files, { desc = '@: Search in git files' })

vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = '@: Show buffers' })
vim.keymap.set('n', '<leader>ds', ':Telescope lsp_document_symbols<CR>', { desc = '@: Document symbols' });

vim.keymap.set('n', 'zz', ':Telescope spell_suggest<CR>', { desc = '@: Spell suggest' });
vim.keymap.set('n', '<leader>?', ':Telescope keymaps<CR>', { desc = '@: Keymaps' });

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
vim.keymap.set('n', '<C-S-F>', ':Telescope live_grep<CR>', { desc = '@: Live grep in all files' });
vim.keymap.set('n', '<leader>sl', ':Telescope live_grep<CR>', { desc = '@: Live grep in all files' });
vim.keymap.set('n', '<leader>sr', ':Telescope lsp_references<CR>', { desc = '@: Search reference (Find usage)' });
vim.keymap.set('n', '<leader>sh', ':Telescope search_history<CR>', { desc = '@: Search history' });
vim.keymap.set("n", "<leader>ut", ':UndotreeToggle<CR>', { desc = '@: Telescope Undo' })

