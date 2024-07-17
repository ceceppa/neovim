require("notify").setup({
    max_width = 80,
    foreground_colour = "#20ffa0",
    render = "compact",
    top_down = false,
})

vim.opt.termguicolors = true
vim.notify = require("notify")
