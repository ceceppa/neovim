require("notify").setup({
    max_width = 80,
    foreground_colour = "#20ffa0",
    render = "compact",
    top_down = false,
    max_width = 80,
})

vim.opt.termguicolors = true
vim.notify = require("notify")
