vim.api.nvim_set_hl(0, "NavicIconsOperator", { default = true, bg = "none", fg = "#eedaad" })
vim.api.nvim_set_hl(0, "NavicText", { default = true, bg = "none", fg = "#eedaad" })
vim.api.nvim_set_hl(0, "NavicSeparator", { default = true, bg = "none", fg = "#eedaad" })

function ColorMyPencils(color, mode)
    vim.api.nvim_set_option("background", mode)

    vim.cmd.colorscheme(color)
end

ColorMyPencils("gruvbox", "dark")
