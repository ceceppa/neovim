local wk = require("which-key")

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

wk.register({
    a = { require("harpoon.mark").add_file, "Add to harpoon" },
    b = {
        name = "Buffers",
        c = { ":bdelete<CR>", "Close current buffer" },
        b = { "<cmd>Telescope buffers<cr>", "Open buffers" },
        o = { ":%bd|e#<CR>", "Kill other buffers" },
    },
    d = {
        name = "Document",
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
    },
    e = { "<cmd>Telescope diagnostics<cr>", "Show errors in all open buffers" },
    f = {
        name = "File tree",
        t = { "<cmd>NvimTreeFindFile<cr>", "Show file tree" },
        c = { "<cmd>NvimTreeClose<cr>", "Close file tree" },
        s = { ":w<CR>", "Save file" },
    },
    g = {
        name = "Git",
        c = { "<cmd>Telescope git_commits<cr>", "Git commits" }, 
        b = { "<cmd>Telescope git_branches<cr>", "Git branches" },
        w = { "<cmd>G blame<cr>", "Git praise" },
        p = { "<cmd>G pull<cr>", "Git pull" },
        s = { vim.cmd.Git, "Git status" },
        d = { '<cmd>GitGutterDiff<cr>', 'Git differ' },
    },
    m = { "<cmd>Telescope marks<cr>", "All marks" },
    p = {
        name = "Project", 
        f = { "<cmd>Telescope find_files<cr>", "Find File" }, 
        g = { "<cmd>Telescope git_files<cr>", "Search in git files" }, 
        p = { "<cmd>Telescope projects<cr>", "Projects" },
        d = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Show all diagnostics errors" },
        q = { ":qa!<CR>", "Quit" },
    },
    r = { 
        name = "Rename",
        w = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace word under cursor" },
    },
    s = {
        name = "Search",
        l = { "<cmd>Telescope live_grep<cr>", "Live grep in all files" },
        r = { "<cmd>Telescope lsp_references<cr>", "Search references" },
        h = { "<cmd>Telescope search_history<cr>", "Show search history" },
        p = { function()
                local builtin = require('telescope.builtin')

                builtin.grep_string({ search = vim.fn.input("Grep in all files > ") });
            end, "Grep in all files" }
    },
    u = { ':UndotreeToggle<CR>:UndoTreeFocus<CR>', 'Undo tree' },
    w = {
        name = "Windows",
        c = { '<C-w>c', 'Close window' },
        v = { '<C-w>v<C-w>l', 'Split vertically' },
        h = { '<C-w>h<C-w>h', 'Split horizzontally' },
        l = { '<C-w>l', 'Focus right window' },
        h = { '<C-w>h', 'Focus left window' },
        k = { '<C-w>k', 'Focus top window' },
        j = { '<C-w>j', 'Focus bottom window' },
        n = { '<C-w>w', 'Focus next window' },
        m = { function()
            local win_config = vim.fn.winsaveview()

            vim.cmd('only')

            vim.fn.winrestview(win_config)
        end , 'Maximize current Window' },
        x = { '<C-w>j<C-w><C-c>', 'Close bottom window' },
    },
    Y = { [["+Y]], "Copy line" },
}, { prefix = "<leader>" })


vim.api.nvim_set_keymap('i', '<Tab>', '<C-y>', {noremap = true})

-- Windows
vim.api.nvim_set_keymap('n', '<leader>1', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>2', '<C-w>l', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>w=', ':vertical resize 120<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap = true})


vim.keymap.set("n", "<leader>ko", ":%bd|e#<CR>") -- kill other buffers

-- Move lines when selected
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- Clear
vim.keymap.set("n", "<leader>c'", "ci'")
vim.keymap.set("n", "<leader>c2", "ci\"")
vim.keymap.set("n", "<leader>c)", "ci)")

