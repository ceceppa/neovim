local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local utils = require("ceceppa.utils")

-- Set up automatic spell checking
-- vim.opt.spelllang = "en"
-- vim.opt.spell = true
-- Enable spelunker.vim. (default: 1)
-- 1: enable
-- 0: disable
vim.g.enable_spelunker_vim = 1

-- Enable spelunker.vim on readonly files or buffer. (default: 0)
-- 1: enable
-- 0: disable
vim.g.enable_spelunker_vim_on_readonly = 0

-- Check spelling for words longer than set characters. (default: 4)
vim.g.spelunker_target_min_char_len = 4

-- Max amount of word suggestions. (default: 15)
vim.g.spelunker_max_suggest_words = 15

-- Max amount of highlighted words in buffer. (default: 100)
vim.g.spelunker_max_hi_words_each_buf = 100

-- Spellcheck type: (default: 1)
-- 1: File is checked for spelling mistakes when opening and saving. This
-- may take a bit of time on large files.
-- 2: Spellcheck displayed words in buffer. Fast and dynamic. The waiting time
-- depends on the setting of CursorHold `set updatetime=1000`.
vim.g.spelunker_check_type = 1

-- Highlight type: (default: 1)
-- 1: Highlight all types (SpellBad, SpellCap, SpellRare, SpellLocal).
-- 2: Highlight only SpellBad.
-- FYI: https://vim-jp.org/vimdoc-en/spell.html#spell-quickstart
vim.g.spelunker_highlight_type = 1

-- Option to disable word checking.
-- Disable URI checking. (default: 0)
vim.g.spelunker_disable_uri_checking = 1

-- Disable email-like words checking. (default: 0)
vim.g.spelunker_disable_email_checking = 1

-- Disable account name checking, e.g. @foobar, foobar@. (default: 0)
-- NOTE: Spell checking is also disabled for JAVA annotations.
vim.g.spelunker_disable_account_name_checking = 1

-- Disable acronym checking. (default: 0)
vim.g.spelunker_disable_acronym_checking = 1

-- Disable checking words in backtick/backquote. (default: 0)
vim.g.spelunker_disable_backquoted_checking = 1

-- Disable default autogroup. (default: 0)
vim.g.spelunker_disable_auto_group = 1

-- Override highlight group name of incorrectly spelled words. (default:
-- 'SpelunkerSpellBad')
vim.g.spelunker_spell_bad_group = 'SpelunkerSpellBad'

-- Override highlight group name of complex or compound words. (default:
-- 'SpelunkerComplexOrCompoundWord')
vim.g.spelunker_complex_or_compound_word_group = 'SpelunkerComplexOrCompoundWord'

-- Override highlight setting.
vim.api.nvim_command('highlight SpelunkerSpellBad cterm=undercurl ctermfg=247 gui=undercurl guifg=#9e9e9e')
vim.api.nvim_command('highlight SpelunkerComplexOrCompoundWord cterm=undercurl ctermfg=NONE gui=underline guifg=NONE')

function show_all_misspellings()
    local spell_bad_list = utils.get_spelunker_bad_list()
    local spell_bad_list_len = #spell_bad_list

    if spell_bad_list_len == 0 then
        vim.notify('No spelling errors found')
        return
    end

    pickers.new({}, {
        prompt_title = 'Spelling errors',
        finder = finders.new_table {
            results = spell_bad_list,
        },
        sorter = conf.file_sorter(),
        preview = false,
        attach_mappings = function(prompt_bufnr, map)
            local go_to_word = function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry(prompt_bufnr)

                if not selection then
                    return
                end

                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('/' .. selection.value .. '<CR>', true, true, true), 'n')
            end

            map('i', '<CR>', go_to_word)
            map('n', '<CR>', go_to_word)

            return true
        end,
    }):find()
end

vim.api.nvim_set_keymap('n', '[s', 'ZP', { desc = 'Go to previous spelling error' })
vim.api.nvim_set_keymap('n', ']s', 'ZN', { desc = 'Go to next spelling error' })
vim.api.nvim_set_keymap('n', '<leader>ss', '<cmd>lua show_all_misspellings()<CR>', { desc = 'Show all spelling errors' })
vim.api.nvim_set_keymap('n', 'zz', 'ZL', { desc = '@: Spell suggest' });

