require("ceceppa.remap")
require("ceceppa.set")

vim.cmd([[autocmd VimEnter * set spell spelllang=en_gb]])
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
vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.g.copilot_filetypes = {
    ["*"] = true,
    ["javascript"] = true,
    ["typescript"] = true,
    ["lua"] = true,
    ["rust"] = true,
    ["c"] = true,
    ["c#"] = true,
    ["c++"] = true,
    ["go"] = true,
    ["python"] = true,
  }

