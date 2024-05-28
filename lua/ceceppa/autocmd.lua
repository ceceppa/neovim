local group = vim.api.nvim_create_augroup('MyAutoCmds', { clear = true })

-- Insert boilerplate text for .tsx files
vim.api.nvim_create_autocmd('BufNewFile', {
    group = group,
    pattern = '*.tsx',
    command = '0r ~/.config/nvim/boilerplates/rfc.tsx',
})

-- Insert boilerplate text for .test.ts and .test.tsx files
vim.api.nvim_create_autocmd('BufNewFile', {
    group = group,
    pattern = '*.test.ts[x]',
    command = '0r ~/.config/nvim/boilerplates/jest.ts',
})

-- Run php-cs-fixer on save for PHP files
vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    pattern = '*.php',
    command = 'silent! lua PhpCsFixerFixFile()',
})
