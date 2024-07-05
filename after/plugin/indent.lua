local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#F7DADC" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#F4E5CA" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#BFDFF8" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#F1E0D1" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#EAF3E4" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#EDD6F4" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#DDF0F2" })
end)

require("ibl").setup { indent = { highlight = highlight } }
