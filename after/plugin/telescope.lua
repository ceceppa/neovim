-- This is your opts table
require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    }
  }
}
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")

local builtin = require('telescope.builtin')

-- Project
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>pg', builtin.git_files, { desc = 'Search in git files' })

vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = 'Show buffers' })
vim.keymap.set('n', '<leader>e', ':Telescope diagnostics<CR>', { desc = 'Show errors in all open buffers' });
vim.keymap.set('n', '<leader>ds', ':Telescope lsp_document_symbols<CR>', { desc = 'Document symbols' });
vim.keymap.set('n', '<leader>m', ':Telescope marks<CR>', { desc = 'Show all marks' });

vim.keymap.set('n', '<leader>gc', ':Telescope git_commits<CR>', { desc = 'Git commits' });
vim.keymap.set('n', '<leader>gb', ':Telescope git_branches<CR>', { desc = 'Git branches' });
vim.keymap.set('n', 's=', ':Telescope spell_suggest<CR>', { desc = 'Spell suggest' });
vim.keymap.set('n', '<leader>?', ':Telescope keymaps<CR>', { desc = 'Keymaps' });
vim.keymap.set('i', '<C-e>', '<C-o>:Telescope registers<CR>', { desc = 'Registers' });

-- Search
vim.keymap.set('n', '<leader>sp', function()
    builtin.grep_string({ search = vim.fn.input("Grep in all files > ") });
end, { desc = 'Grep in all files' })

vim.keymap.set('n', '<leader>sw', ':Telescope grep_string<CR>', { desc = 'Search word under cursor' });
vim.keymap.set('n', '<leader>sl', ':Telescope live_grep<CR>', { desc = 'Live grep in all files' });
vim.keymap.set('n', '<leader>sr', ':Telescope lsp_references<CR>', { desc = 'Search reference (Find usage)' });
vim.keymap.set('n', '<leader>sh', ':Telescope search_history<CR>', { desc = 'Search history' });
