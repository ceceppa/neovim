require("notify").setup({
  max_width = 80,
  foreground_colour = "#20ffa0",
  render = "compact"
})

vim.opt.termguicolors = true
vim.notify = require("notify")

-- vim.api.nvim_set_hl(0, "NotifyERRORBorder", { guifg = "#8A1F1F" })
-- vim.api.nvim_set_hl(0, "NotifyWARNBorder", { guifg = "#79491D" })
-- vim.api.nvim_set_hl(0, "NotifyINFOBorder", { guifg = "#4F6752" })
-- vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { guifg = "#616161" })
-- vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { guifg = "#4F3552" })

vim.cmd([[
highlight NotifyERRORIcon guifg=#A90000
highlight NotifyWARNIcon guifg=#9E5C00
highlight NotifyINFOIcon guifg=#317000
highlight NotifyDEBUGIcon guifg=#616161
highlight NotifyTRACEIcon guifg=#D484FF
highlight NotifyERRORTitle  guifg=#A90000
highlight NotifyWARNTitle guifg=#9E5C00
highlight NotifyINFOTitle guifg=#317000
highlight NotifyDEBUGTitle  guifg=#616161
highlight NotifyTRACETitle  guifg=#8500CC
]])
