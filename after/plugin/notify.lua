require("notify").setup({
  background_colour = "#000000",
  top_down = false,
  max_width = 80,
})

vim.opt.termguicolors = true
vim.notify = require("notify")

