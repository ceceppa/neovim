vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Explore, { desc = '@: directory listing' })

vim.api.nvim_set_keymap('n', '<C-S-S>', ':w<CR>', { noremap = true, desc = '@: Save file' })
vim.api.nvim_set_keymap('n', '<C-y>', 'viwy', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-S-y>', 'Vy', { noremap = true, desc = 'Yank line' })
vim.api.nvim_set_keymap('n', '<C-S-p>', 'Vp', { noremap = true, desc = 'Replace line with yanked', silent = true })

-- Clear content within matches
vim.api.nvim_set_keymap('n', '<C-x>', 'ciw', { noremap = true, desc = '@: Clear word under cursor' })
vim.api.nvim_set_keymap('n', "<C-'>", "ci'",
    { noremap = true, silent = true, desc = '@: Clear content inside single quotes' })
vim.api.nvim_set_keymap('n', "<C-2>", 'ci"',
    { noremap = true, silent = true, desc = '@: Clear content inside double quotes' })
vim.api.nvim_set_keymap('n', "<C-9>", 'ci(',
    { noremap = true, silent = true, desc = '@: Clear content inside parentheses (' })
vim.api.nvim_set_keymap('n', "<C-0>", 'ci[',
    { noremap = true, silent = true, desc = '@: Clear content inside square brackets [' })
vim.api.nvim_set_keymap('n', "<C-8>", 'ci{',
    { noremap = true, silent = true, desc = '@: Clear content inside curly brackets {' })

-- Clear content around matches
vim.api.nvim_set_keymap('n', "<leader>'", "ca'",
    { noremap = true, silent = true, desc = '@: Clear content around single quotes' })
vim.api.nvim_set_keymap('n', '<leader>"', 'ca"',
    { noremap = true, silent = true, desc = '@: Clear content around double quotes' })
vim.api.nvim_set_keymap('n', "<leader>(", 'ca(',
    { noremap = true, silent = true, desc = '@: Clear content around parentheses (' })
vim.api.nvim_set_keymap('n', "<leader>{", 'ca{',
    { noremap = true, silent = true, desc = '@: Clear content around curly brackets {' })
vim.api.nvim_set_keymap('n', "<leader>[", 'ca[',
    { noremap = true, silent = true, desc = '@: Clear content around square brackets [' })

-- Replace content within symbols
vim.api.nvim_set_keymap('n', "<leader>r'", "vi'pvi'y",
    { noremap = true, silent = true, desc = '@: Replace content inside single quotes' })
vim.api.nvim_set_keymap('n', '<leader>r"', 'vi"pvi"y',
    { noremap = true, silent = true, desc = '@: Replace content inside double quotes' })
vim.api.nvim_set_keymap('n', "<leader>r(", 'vi(pvi(y',
    { noremap = true, silent = true, desc = '@: Replace content inside parentheses (' })
vim.api.nvim_set_keymap('n', "<leader>r{", 'vi{pvi{y',
    { noremap = true, silent = true, desc = '@: Replace content inside curly brackets {' })
vim.api.nvim_set_keymap('n', "<leader>rp", 'viwpviwy',
    { noremap = true, silent = true, desc = '@: Replace word under cursor with yank' })

-- Copy content within symbols
vim.api.nvim_set_keymap('n', "<leader>y'", "vi'y",
    { noremap = true, silent = true, desc = '@: Copy content inside single quotes' })
vim.api.nvim_set_keymap('n', '<leader>y"', 'vi"y',
    { noremap = true, silent = true, desc = '@: Copy content inside double quotes' })
vim.api.nvim_set_keymap('n', "<leader>y(", 'vi(y',
    { noremap = true, silent = true, desc = '@: Copy content inside parentheses (' })
vim.api.nvim_set_keymap('n', "<leader>y{", 'vi{y',
    { noremap = true, silent = true, desc = '@: Copy content inside curly brackets {' })
vim.api.nvim_set_keymap('n', "<C-S-D>", 'yyp', { noremap = true, silent = true, desc = '@: Duplicate ine' })
vim.api.nvim_set_keymap('n', "<leader>v$", 'v$y',
    { noremap = true, silent = true, desc = '@: Copy content from cursor until end of line' })

-- Select content within symbols
vim.api.nvim_set_keymap('n', "<leader>v'", "vi'",
    { noremap = true, silent = true, desc = '@: Select content inside single quotes' })
vim.api.nvim_set_keymap('n', '<leader>v"', 'vi"',
    { noremap = true, silent = true, desc = '@: Select content inside double quotes' })
vim.api.nvim_set_keymap('n', "<leader>v(", 'vi(',
    { noremap = true, silent = true, desc = '@: Select content inside parentheses (' })
vim.api.nvim_set_keymap('n', "<leader>v{", 'vi{',
    { noremap = true, silent = true, desc = '@: Select content inside curly brackets {' })
vim.api.nvim_set_keymap('n', "<C-S-->", '_i',
    { noremap = true, silent = true, desc = '@: Move cursor to first non-blank character and insert mode' })
vim.api.nvim_set_keymap('i', "<C-S-->", '<C-O>_',
    { noremap = true, silent = true, desc = '@: Move cursor to first non-blank character and insert mode' })



-- Insert mode
vim.api.nvim_set_keymap('i', '<C-S-x>', '<C-o>dd', { noremap = true, desc = '@: Save file' })
vim.api.nvim_set_keymap('i', '<C-S-s>', '<C-o>:w<CR>', { noremap = true, desc = '@: Save file' })
vim.api.nvim_set_keymap('i', '<Tab>', '<C-y>', { noremap = true, desc = '@: Autocomplete' })
vim.api.nvim_set_keymap('i', '<C-v>', '<C-r><C-o>*', { noremap = true, desc = '@: Paste' })
vim.api.nvim_set_keymap('i', '<C-b>', '<C-o>diw', { noremap = true, desc = '@: Delete word under cursor' })
vim.api.nvim_set_keymap('i', '<C-q>', '<C-o>de', { noremap = true, desc = '@: Delete characters after cursor' })
vim.api.nvim_set_keymap('i', "<C-2>", '<C-o>ci"',
    { noremap = true, silent = true, desc = '@: Clear content inside double quotes' })
vim.api.nvim_set_keymap('i', "<C-'>", "<C-o>ci'",
    { noremap = true, silent = true, desc = '@: Clear content inside single quotes' })
vim.api.nvim_set_keymap('i', "<C-9>", '<C-o>ci(',
    { noremap = true, silent = true, desc = '@: Clear content inside parentheses (' })
vim.api.nvim_set_keymap('i', "<C-0>", '<C-o>ci[',
    { noremap = true, silent = true, desc = '@: Clear content inside square brackets [' })
vim.api.nvim_set_keymap('i', "<C-8>", '<C-o>ci{',
    { noremap = true, silent = true, desc = '@: Clear content inside curly brackets {' })

-- Select word
vim.api.nvim_set_keymap('n', "<leader>w", 'viw', { noremap = true, silent = true, desc = '@: Select word' })

-- Custom Insert
vim.api.nvim_set_keymap('n', "<C-S-i>", 'wi', { noremap = true, silent = true, desc = '@: Insert after the word' })

-- Windows
vim.api.nvim_set_keymap('n', '<leader>w=', ':vertical resize 120<CR>',
    { noremap = true, desc = '@: Equalize windows vertical size' })
vim.api.nvim_set_keymap('n', '<leader>wv', '<C-w>v', { noremap = true, desc = '@: Equalize windows vertical size' })
vim.api.nvim_set_keymap('n', '<C-n>', '<C-w>w', { noremap = true, desc = '@: Focus next window' })
vim.api.nvim_set_keymap('n', '<C-S-n>', '<C-w>W', { noremap = true, desc = '@: Focus previous window' })
vim.keymap.set("n", "<C-f><C-f>", vim.lsp.buf.format, { desc = '@: Format file' })
vim.keymap.set("i", "<C-f><C-f>", vim.lsp.buf.format, { desc = '@: Format file' })
vim.keymap.set("n", "<C-f><C-j>", ':%!jq .', { desc = '@: Format JSON file' })
vim.api.nvim_set_keymap('n', '<leader>wm', ':lua MaximizeCurrentWindow()<CR>', { noremap = true, silent = true })

function MaximizeCurrentWindow()
    -- Store the current window configuration
    local win_config = vim.fn.winsaveview()

    -- Maximize the current window
    vim.cmd('only')

    -- Restore the previous window configuration
    vim.fn.winrestview(win_config)
end

-- Move lines when selected
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = '@: Move selection down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = '@: Move selection up' })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = '@: Page down' })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = '@: Page up' })
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Other stuff
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "Q", "<nop>")
vim.api.nvim_set_keymap('n', '<C-q><C-q>', ':qa<CR>', { noremap = true, desc = '@: Quit' })

vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = '@: Make it rain' });

-- Buffers
vim.keymap.set("n", "<leader>bc", ":lua require('bufdelete').bufdelete(0, false)<CR>",
    { desc = '@: Close current buffer' })
vim.keymap.set("n", "<leader>bo", ":%bd|e#<CR>", { desc = '@: Kill other buffers' })
vim.keymap.set("n", "<leader>bkk", ":%bd|e!#<CR>", { desc = '@: Kill other buffers!!!' })
vim.keymap.set("n", "<leader>bn", ":enew<CR>", { desc = '@: New empty buffer' })

-- Replace
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = '@: Replace word under cursor' })
vim.keymap.set("n", "<leader>rc", [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = '@: Replace characters under cursor' })

-- Surround
function surround_word_with(input)
    local word_under_cursor = vim.fn.expand("<cword>")

    local opposite = {
        ["("] = ")",
        ["["] = "]",
        ["{"] = "}",
        ["<"] = ">"
    }

    local closing = opposite[input] or input

    local keys = "ciw" .. input .. word_under_cursor .. closing
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', {})
end

function surround_word_with_input()
    local input = vim.fn.input("Enter the surrounding string:")

    if string.len(input) == 0 then
        return
    end

    surround_word_with(input)
end

vim.api.nvim_set_keymap('n', '<C-s>', [[<Cmd>lua surround_word_with_input()<CR>]],
    { noremap = true, silent = true, desc = '@: Surround word with input' })

-- Surround content within symbols
vim.api.nvim_set_keymap('n', "<leader>s'", [[<Cmd>lua surround_word_with("'")<CR>]],
    { noremap = true, silent = true, desc = '@: Surround word with single quotes' })
vim.api.nvim_set_keymap('n', "<leader>s(", [[<Cmd>lua surround_word_with("(")<CR>]],
    { noremap = true, silent = true, desc = '@: Surround word with double quotes' })
vim.api.nvim_set_keymap('n', "<leader>s{", [[<Cmd>lua surround_word_with("{")<CR>]],
    { noremap = true, silent = true, desc = '@: Surround word with parentheses' })
vim.api.nvim_set_keymap('n', "<leader>s[", [[<Cmd>lua surround_word_with("[")<CR>]],
    { noremap = true, silent = true, desc = '@: Surround word with square brackets' })
vim.api.nvim_set_keymap('n', "<leader>s<", [[<Cmd>lua surround_word_with("<")<CR>]],
    { noremap = true, silent = true, desc = '@: Surround word with angle brackets' })
vim.api.nvim_set_keymap('n', '<leader>s"', [[<Cmd>lua surround_word_with('"')<CR>]],
    { noremap = true, silent = true, desc = '@: Surround word with double quotes' })

-- Insert mode
vim.api.nvim_set_keymap('i', '<C-L>', '<Esc>$a', { noremap = true, desc = '@: Move cursor to end of line' })
vim.api.nvim_set_keymap('i', '<C-J>', '<Esc>^i', { noremap = true, desc = '@: Move cursor to beginning of line' })
vim.api.nvim_set_keymap('i', '<C-d>', '<C-o>:delete<CR>', { noremap = true, desc = '@: Delete line' })

-- Replace all occurrences of word under cursor
vim.api.nvim_set_keymap('n', '<leader>rg', [[<Cmd>lua replace_globally()<CR>]],
    { noremap = true, silent = true, desc = '@: Replace all occurrences of word under cursor (globally)' })
vim.api.nvim_set_keymap('n', '<C-S-R>', [[<Cmd>lua replace_globally()<CR>]],
    { noremap = true, silent = true, desc = '@: Replace all occurrences of word under cursor (globally)' })

local function do_replace_globally(from, to)
    vim.cmd('cdo s/' .. from .. '/' .. to .. '/g | update | bd')

    print("✅ Done: " .. from .. " replaced with " .. to .. " globally.")
end

function replace_globally()
    local word_under_cursor = vim.fn.expand("<cword>")
    local from = vim.fn.input("Replace (globally) all occurrences of: ", word_under_cursor)

    if string.len(from) == 0 then
        print("Replace operation cancelled.")

        return
    end

    local to = vim.fn.input("Replace all occurrences of <" .. from .. "> with: ", from)

    if string.len(to) == 0 then
        print("Replace operation cancelled.")

        return
    end

    require('telescope.builtin').grep_string({ search = from })
    vim.defer_fn(function()
        vim.api.nvim_input('<C-q>')

        vim.defer_fn(
            function()
                do_replace_globally(from, to)
            end, 200)
    end, 1000)
end

vim.keymap.set("n", "<leader>do", "<cmd>AerialToggle!<CR>", { desc = '@: Aerial toggle (document outline)' })

vim.keymap.set("n", "[t", "<cmd>AerialGo<CR>", { desc = '@: AerialGo (jump to the beginning of component)' })
vim.keymap.set("n", "<C-S-X>", "ddi", { desc = '@: Delete entire line' })

vim.keymap.set("n", "<C-.>", "V>", { desc = '@: Indent entire line' })
vim.keymap.set("n", "<C-S-.>", "V<", { desc = '@: Deintend entire line' })

local function search_selection_on_google(selection)
    if string.len(selection) == 0 then
        return
    end

    os.execute("open https://www.google.com/search?q=" .. selection)
end

vim.keymap.set('n', '<C-S-O>', function()
    search_selection_on_google(vim.fn.expand("<cword>"))
end, { desc = '@: Search selection on Google' })

vim.keymap.set("v", "<C-S-O>", function()
    vim.cmd.normal { '"zy', bang = true }
    search_selection_on_google(vim.fn.getreg("z"))
end, { desc = '@: Search selection on Google' })
