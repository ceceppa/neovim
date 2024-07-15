vim.ceceppa = {
    current_git_action = nil,
    package_manager = 'yarn',
}

require("ceceppa.remap")
require("ceceppa.set")
require("ceceppa.git")
require("ceceppa.autocmd")
require("ceceppa.lint")
require("ceceppa.projects")
require("ceceppa.runner")
require("ceceppa.diagnostics")

vim.api.nvim_set_option("clipboard","unnamed")

vim.g.gitgutter_sign_added = '󰐒 '
vim.g.gitgutter_sign_modified = '󰤀 '
vim.g.gitgutter_sign_removed = '󰐓 '
vim.g.gitgutter_sign_removed_first_line = '^^'
vim.g.gitgutter_sign_removed_above_and_below = '{'
vim.g.gitgutter_sign_modified_removed = ' '
vim.g.gitgutter_sign_allow_clobber = 1
vim.g.gitgutter_set_sign_backgrounds = 1

vim.cmd("highlight GitGutterAdd guifg=#73ff00 ctermfg=2")
vim.cmd("highlight GitGutterChange guifg=#f0dbff ctermfg=3")
vim.cmd("highlight GitGutterDelete guifg=#ffa8a8 ctermfg=1")

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-.>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.g.copilot_filetypes = {
    ["*"] = false,
    ["lua"] = true,
    ["php"] = true,
  }

vim.o.guicursor = 'n-v-i-sm:block,c-ci-ve-i:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'

vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
