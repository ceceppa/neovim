local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local utils = require "telescope.utils"
local actions = require "telescope.actions"

local sorting_comparator = function(opts)
    local current_buf = vim.api.nvim_get_current_buf()
    local comparators = {
        -- sort results by bufnr (prioritize cur buf), severity, lnum
        buffer = function(a, b)
            if a.bufnr == b.bufnr then
                if a.type == b.type then
                    return a.lnum < b.lnum
                else
                    return a.type < b.type
                end
            else
                if a.bufnr == current_buf then
                    return true
                end
                if b.bufnr == current_buf then
                    return false
                end
                return a.bufnr < b.bufnr
            end
        end,
        severity = function(a, b)
            if a.type < b.type then
                return true
            elseif a.type > b.type then
                return false
            end

            if a.bufnr == b.bufnr then
                return a.lnum < b.lnum
            elseif a.bufnr == current_buf then
                return true
            elseif b.bufnr == current_buf then
                return false
            else
                return a.bufnr < b.bufnr
            end
        end,
    }

    local sort_by = vim.F.if_nil(opts.sort_by, "buffer")
    return comparators[sort_by]
end

local convert_diagnostic_type = function(severities, severity)
    -- convert from string to int
    if type(severity) == "string" then
        -- make sure that e.g. error is uppercased to ERROR
        return severities[severity:upper()]
    end
    -- otherwise keep original value, incl. nil
    return severity
end

local function diagnostic_exists(diagnostic, diagnostics)
    for _, d in ipairs(diagnostics) do
        if d.filename == diagnostic.filename and d.lnum == diagnostic.lnum and d.col == diagnostic.col then
            return true
        end
    end

    return false
end

local function add_diagnostic_entries(diagnostics, values)
    local severities = vim.diagnostic.severity

    for _, d in ipairs(diagnostics) do
        if not diagnostic_exists(d, values) then
            table.insert(values, {
                bufnr = 0,
                filename = d.filename,
                lnum = d.lnum,
                col = d.col,
                text = d.text,
                type = d.type,
                severity = d.severity or severities[1],
                source = d.source,
            })
        end
    end

    return diagnostics
end

local get_nvim_diagnostics = function(opts)
    opts = vim.F.if_nil(opts, {})
    local severities = vim.diagnostic.severity

    opts.severity = convert_diagnostic_type(severities, opts.severity)
    opts.severity_limit = convert_diagnostic_type(severities, opts.severity_limit)
    opts.severity_bound = convert_diagnostic_type(severities, opts.severity_bound)

    local diagnostics = {}
    local buffer_names = {}
    local buffers = vim.api.nvim_list_bufs()

    for _, buffer_number in ipairs(buffers) do
        local buffer_diagnostics = vim.diagnostic.get(buffer_number)

        if buffer_names[buffer_number] == nil then
            buffer_names[buffer_number] = vim.api.nvim_buf_get_name(buffer_number)
        end

        for _, diagnostic in ipairs(buffer_diagnostics) do
            table.insert(diagnostics, {
                filename = buffer_names[buffer_number],
                lnum = diagnostic.lnum,
                col = diagnostic.col,
                type = severities[diagnostic.severity] or severities[1],
                text = diagnostic.message,
                bufnr = buffer_number,
                source = diagnostic.source,
            })
        end
    end

    return diagnostics
end

local get_diagnostics = function(opts)
    local items = get_nvim_diagnostics(opts)
    local lint = require('lint').get_output()

    if #lint > 0 then
        add_diagnostic_entries(lint, items)
    end

    local tsc = require('tsc').get_output()
    if #tsc > 0 then
        add_diagnostic_entries(tsc, items)
    end

    table.sort(items, sorting_comparator(opts))

    return items
end

local function show_diagnostics(filter_type)
    local opts = {}

    if opts.bufnr ~= 0 then
        opts.bufnr = nil
    end

    if type(opts.bufnr) == "string" then
        opts.bufnr = tonumber(opts.bufnr)
    end
    if opts.bufnr ~= nil then
        opts.path_display = vim.F.if_nil(opts.path_display, "hidden")
    end

    local locations = get_diagnostics(opts)

    if #locations == 0 then
        vim.notify("No diagnostics found", vim.log.levels.INFO)
        return
    end

    local filtered_diagnostics = {}

    for _, diagnostic in ipairs(locations) do
        if filter_type == nil or diagnostic.type == filter_type then
            table.insert(filtered_diagnostics, diagnostic)
        end
    end

    local suffix = "ALL"

    if filter_type ~= nil then
        suffix = string.format("%s", filter_type)
    end

    pickers
        .new({}, {
            prompt_title = "Workspace DiagnosticsL (" .. suffix .. " " .. #filtered_diagnostics .. ")",
            finder = finders.new_table {
                results = filtered_diagnostics,
                entry_maker = make_entry.gen_from_diagnostics({}),
            },
            previewer = conf.qflist_previewer({}),
            attach_mappings = function(prompt_buffer_number, map)
                local show_only = function(what)
                    return function()
                        actions.close(prompt_buffer_number)

                        show_diagnostics(what)
                    end
                end

                map("i", "<C-e>", show_only('ERROR'))
                map("i", "<C-w>", show_only('WARN'))
                map("i", "<C-i>", show_only('INFO'))
                map("i", "<C-a>", show_only())

                return true
            end
        })
        :find()
end

vim.api.nvim_create_user_command("DiagnosticsShow", function(args)
    show_diagnostics(args.fargs[1])
end, { desc = '@ Ceceppa diagnostics', nargs = '*' })

vim.keymap.set('n', '<leader>e', ':DiagnosticsShow<CR>', { desc = '@: Show errors in all open buffers' });

return {
    get_diagnostics = get_diagnostics

}
