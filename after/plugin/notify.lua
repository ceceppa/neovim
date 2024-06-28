require("notify").setup({
  background_colour = "#000000",
  max_width = 80,
  foreground_colour = "#20ffa0",
  render = "compact"
  
})

vim.opt.termguicolors = true
vim.notify = require("notify")

