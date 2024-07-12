local utils = require('ceceppa.utils')

vim.ceceppa.errors = {
    _waiting = 0,
    show_errors = false,
    running = false,
    lint = {},
    tsc = {},
}

local function parse_lint_output(output)
    local errors = {}

    if output == nil then
        return errors
    end

    local previous_line = ""
    for _, line in ipairs(output) do
        local lineno, colno, t, message = line:match("^%s+(%d+):(%d+)%s+(%w+)%s+(.*)$")

        if lineno ~= nil and colno ~= nil then
            local text = message
            local type = "ERROR"

            if t ~= "error" then
                type = "WARN"
            end

            table.insert(errors, {
                filename = previous_line,
                lnum = tonumber(lineno),
                col = tonumber(colno),
                text = text,
                type = type
            })
        end

        previous_line = line
    end

    return errors
end

local function process_completed()
    vim.ceceppa.errors._waiting = vim.ceceppa.errors._waiting - 1

    if vim.ceceppa.errors._waiting == 0 then
        vim.ceceppa.errors.running = false
    end
end

local function do_command(command, description, args, callback, is_watch)
    vim.ceceppa.errors.running = true

    vim.ceceppa.errors._waiting = vim.ceceppa.errors._waiting + 1

    utils.execute_command(command, description, args, callback, true, is_watch)
end

function do_yarn_lint(is_watch)
    if vim.fn.filereadable('package.json') ~= 1 or vim.ceceppa.errors.running then
        return
    end

    vim.ceceppa.errors.show_errors = true

    do_command("yarn", "Linting", { 'lint' }, function(data)
        vim.ceceppa.errors.lint = parse_lint_output(data)
        process_completed()
    end, is_watch)
end

if vim.fn.filereadable('package.json') == 1 then
    local scripts = vim.fn.json_decode(vim.fn.readfile('package.json'))['scripts']

    if scripts == nil then
        return
    end

    -- Check if there is a "lint" command in the package.json
    local lint_command = vim.fn.json_decode(vim.fn.readfile('package.json'))['scripts']['lint']

    if lint_command == nil then
        return
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.{ts,tsx,js,jsx}",
        desc = "Run lint on save",
        callback = function()
            do_yarn_lint(true)
        end,
    })
end

do_yarn_lint(true)

vim.api.nvim_set_keymap('n', '<leader>tc', ':lua do_yarn_lint()<CR>',
    { noremap = true, desc = '@: Linting & TypeScript check' })
