vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = 'directory listing' })

vim.api.nvim_set_keymap('n', '<leader>fs', ':w<CR>', {noremap = true, desc = 'Save file'})
vim.api.nvim_set_keymap('n', '<C-y>', 'viwy', {noremap = true})

-- Clear content within matches
vim.api.nvim_set_keymap('n', '<C-x>', 'ciw', {noremap = true})
vim.api.nvim_set_keymap('n', "<C-'>", "ci'", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<C-2>", 'ci"', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<C-9>", 'ci(', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<C-0>", 'ci[', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<C-}>", 'ci{', {noremap = true, silent = true})

-- Clear content around matches
vim.api.nvim_set_keymap('n', "<leader>'", "ca'", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>"', 'ca"', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>(", 'ca(', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>{", 'ca{', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>[", 'ca[', {noremap = true, silent = true})

-- Replace content within symbols
vim.api.nvim_set_keymap('n', "<leader>r'", "vi'p", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>r"', 'vi"p', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>r(", 'vi(p', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>r{", 'vi{p', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>rp", 'viwp', {noremap = true, silent = true})

-- Copy content within symbols
vim.api.nvim_set_keymap('n', "<leader>y'", "vi'y", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>y"', 'vi"y', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>y(", 'vi(y', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>y{", 'vi{y', {noremap = true, silent = true})

-- Select content within symbols
vim.api.nvim_set_keymap('n', "<leader>v'", "vi'", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>v"', 'vi"', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>v(", 'vi(', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>v{", 'vi{', {noremap = true, silent = true})

-- TypeScript
vim.api.nvim_set_keymap('n', '<leader>tc', ':!yarn lint && yarn ts:check<CR>', {noremap = true, desc = 'TypeScript check'})

-- Insert mode
vim.api.nvim_set_keymap('i', '<C-f><C-s>', '<C-o>:w<CR>', {noremap = true, desc = 'Save file'})
vim.api.nvim_set_keymap('i', '<C-f>s', '<C-o>:w<CR>', {noremap = true, desc = 'Save file'})
vim.api.nvim_set_keymap('i', '<Tab>', '<C-y>', {noremap = true, desc = 'Autocomplete'})
vim.api.nvim_set_keymap('i', '<C-v>', '<C-r><C-o>*', {noremap = true, desc = 'Paste'})
vim.api.nvim_set_keymap('i', '<C-b>', '<C-o>diw', {noremap = true, desc = 'Delete word under cursor'})
vim.api.nvim_set_keymap('i', '<C-q>', '<C-o>de', {noremap = true, desc = 'Delete characters after cursor'})

-- Select word
vim.api.nvim_set_keymap('n', "<leader>w", 'viw', {noremap = true, silent = true})


-- Windows
vim.api.nvim_set_keymap('n', '<leader>w=', ':vertical resize 120<CR>', {noremap = true, desc = 'Equalize windows vertical size'})
vim.api.nvim_set_keymap('n', '<leader>wv', '<C-w>v', {noremap = true, desc = 'Equalize windows vertical size'})
vim.api.nvim_set_keymap('n', '<C-n>', '<C-w>w', {noremap = true, desc = 'Focus next window'})
vim.api.nvim_set_keymap('n', '<C-p>', '<C-w>W', {noremap = true, desc = 'Focus previous window'})
vim.keymap.set("n", "<C-f><C-f>", vim.lsp.buf.format, { desc = 'Format file' })
vim.keymap.set("n", "<C-f><C-j>", ':%!jq .', { desc = 'Format JSON file' })
vim.api.nvim_set_keymap('n', '<leader>wm', ':lua MaximizeCurrentWindow()<CR>', {noremap = true, silent = true})

function MaximizeCurrentWindow()
  -- Store the current window configuration
  local win_config = vim.fn.winsaveview()

  -- Maximize the current window
  vim.cmd('only')

  -- Restore the previous window configuration
  vim.fn.winrestview(win_config)
end

-- Move lines when selected
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Page down' })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Page up' })
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Other stuff
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "Q", "<nop>")
vim.api.nvim_set_keymap('n', '<C-q><C-q>', ':qa<CR>', {noremap = true, desc = 'Quit'})

vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = 'Make it rain' });

-- Buffers
vim.keymap.set("n", "<leader>bc", ':bdelete<CR>', { desc = 'Close current buffer' })
vim.keymap.set("n", "<leader>bo", ":%bd|e#<CR>", { desc = 'Kill other buffers' })
vim.keymap.set("n", "<leader>boo", ":%bd|e!#<CR>", { desc = 'Kill other buffers' })

-- Replace
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })
vim.keymap.set("n", "<leader>rc", [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace characters under cursor' })

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

vim.api.nvim_set_keymap('n', '<C-s>', [[<Cmd>lua surround_word_with_input()<CR>]], {noremap = true, silent = true})

-- Surround content within symbols
vim.api.nvim_set_keymap('n', "<leader>s'", [[<Cmd>lua surround_word_with("'")<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>s(", [[<Cmd>lua surround_word_with("(")<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>s{", [[<Cmd>lua surround_word_with("{")<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>s[", [[<Cmd>lua surround_word_with("[")<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<leader>s<", [[<Cmd>lua surround_word_with("<")<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>s"', [[<Cmd>lua surround_word_with('"')<CR>]], {noremap = true, silent = true})

