local utils = require('ceceppa.utils')
local tsc_utils = require('tsc.utils')

local LINT_INTERVAL = 60000

vim.ceceppa = {
    _waiting = 0,
    running = false,
    errors = {
        lint = {},
        tsc = {},
    }
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
    vim.ceceppa._waiting = vim.ceceppa._waiting - 1

    if vim.ceceppa._waiting == 0 then
        vim.ceceppa.running = false
    end
end

local function do_command(command, description, args, callback, is_watch)
    vim.ceceppa.running = true

    vim.ceceppa._waiting = vim.ceceppa._waiting + 1

    utils.execute_command(command, description, args, callback, true, is_watch)
end

function do_yarn_lint(is_watch)
    if vim.fn.filereadable('package.json') ~= 1 or vim.ceceppa.running then
        return
    end

    do_command("yarn", "Linting", { 'lint' }, function(data)
        vim.ceceppa.errors.lint = parse_lint_output(data)
        process_completed()
    end, is_watch)

    -- utils.execute_command("yarn", "Linting", { 'lint' }, function(data)
    --     vim.ceceppa.errors.lint = parse_lint_output(data)
    --     process_completed()
    -- end, true, is_watch)

    -- local ts_check = vim.fn.json_decode(vim.fn.readfile('package.json'))['scripts']['ts:check'];
    --
    --
    -- if ts_check ~= nil then
    --     do_command("yarn", "TypeScript check", { 'ts:check' }, function(data)
    --         local result = tsc_utils.parse_tsc_output(data, { pretty_errors = true })
    --
    --         vim.ceceppa.errors.tsc = result.errors
    --         process_completed()
    --     end, is_watch)
    --
    --     -- utils.execute_command(
    --     --     "yarn",
    --     --     "Linting", { 'ts:check' },
    --     --     function(data)
    --     --         local result = tsc_utils.parse_tsc_output(data, { pretty_errors = true })
    --     --
    --     --         vim.ceceppa.errors.tsc = result.errors
    --     --     end,
    --     --     true,
    --     --     is_watch)
    -- end

    if is_watch then
        vim.defer_fn(
            function() do_yarn_lint(is_watch) end
            , LINT_INTERVAL)
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
