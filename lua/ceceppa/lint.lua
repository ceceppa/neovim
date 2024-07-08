local utils = require('ceceppa.utils')
local tsc_utils = require('tsc.utils')

vim.ceceppa = {
    errors = {}
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
            local type = "E"

            if t ~= "error" then
                type = "W"
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

function do_yarn_lint(is_watch)
    utils.execute_command("yarn", "Linting", { 'lint' }, function()
        if vim.fn.filereadable('package.json') ~= 1 then
            return
        end

        local ts_check = vim.fn.json_decode(vim.fn.readfile('package.json'))['scripts']['ts:check'];

        if ts_check ~= nil then
            utils.execute_command(
                "yarn",
                "Linting", { 'ts:check' },
                nil,
                function(data)
                    local result = tsc_utils.parse_tsc_output(data, { pretty_errors = true })

                    return result.errors
                end,
                is_watch)
        end
    end, parse_lint_output, is_watch)

    if is_watch then
        vim.defer_fn(
            function() do_yarn_lint(is_watch) end
            , 30000)
    end
end

if vim.fn.filereadable('package.json') == 1 then
    -- Check if there is a "lint" command in the package.json
    local lint_command = vim.fn.json_decode(vim.fn.readfile('package.json'))['scripts']['lint']

    if lint_command == nil then
        return
    end

    -- vim.notify("Linting & TypeScript check", "Watching for changes every 30s", nil, { title = "Watcher" })

    do_yarn_lint(true)
end

vim.api.nvim_set_keymap('n', '<leader>tc', ':lua do_yarn_lint()<CR>',
    { noremap = true, desc = '@: Linting & TypeScript check' })

