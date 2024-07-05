vim.keymap.set("n", "]h", function() vim.cmd("GitGutterNextHunk") end, { desc = "GitGutter Next Hunk" })
vim.keymap.set("n", "[h", function() vim.cmd("GitGutterPrevHunk") end, { desc = "GitGutter Prev Hunk" })

