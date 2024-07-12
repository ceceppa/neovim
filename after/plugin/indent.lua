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
local background = vim.api.nvim_get_option("background")

if background == 'dark' then
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end)
else
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#F7DADC" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#F4E5CA" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#BFDFF8" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#F1E0D1" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#EAF3E4" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#EDD6F4" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#DDF0F2" })
    end)
end

require("ibl").setup {}
