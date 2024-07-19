local utils = require('ceceppa.utils')
local projects = require('projects')
local lint = require('lint')
local diagnostics = require('ceceppa.diagnostics')
local TIMEOUT = 3000
local HOURGLASSES = { '', '', '' }

-- helper function to loop over string lines
-- copied from https://stackoverflow.com/a/19329565
local function iterlines(s)
    if s:sub(-1) ~= "\n" then s = s .. "\n" end
    return s:gmatch("(.-)\n")
end

-- find directory
local function find_dir(d)
    -- return if root
    if d == '/' then
        return d
    end
    -- initialize git_state variable
    if vim.b.git_state == nil then
        vim.b.git_state = { '', '', '', '' }
    end
    -- fix terminal
    if d:find("term://") ~= nil then
        return "/tmp"
    end
    -- fix fzf
    if d:find("/tmp/.*FZF") ~= nil then
        return "/tmp"
    end
    -- fix fugitive etc.
    if d:find("^%w+://") ~= nil then
        vim.b.git_state[1] = ' ' .. d:gsub("^(%w+)://.*", "%1") .. ' '
        d = d:gsub("^%w+://", "")
    end
    -- check renaming
    local ok, _, code = os.rename(d, d)
    if not ok then
        if code ~= 2 then
            -- all other than not existing
            return d
        end
        -- not existing
        local newd = d:gsub("(.*/)[%w._-]+/?$", "%1")
        return find_dir(newd)
    end
    -- d ok
    return d
end

-- get git status
local git_is_waiting = true
local old_branch_col = nil

local function git_status()
    git_is_waiting = false
    vim.b.git_state = { '', '', '' }
    -- get & check file directory
    local file_dir = find_dir(vim.fn.expand("%:p:h"))
    -- check fugitive etc.
    if vim.b.git_state[1] ~= "" then
        return 'u'
    end
    -- capture git status call
    local cmd = "git -C '" .. file_dir .. "' status --porcelain -b 2> /dev/null"
    local handle = assert(io.popen(cmd, 'r'), '')
    -- output contains empty line at end (removed by iterlines)
    local output = assert(handle:read('*a'))
    -- close io
    handle:close()

    local git_state = { '', '', '', '' }
    -- branch coloring: 'o': up to date with origin; 'd': head detached; 'm': not up to date with origin
    local branch_col = 'o'
    old_branch_col = branch_col

    -- check if git repo
    if output == '' then
        -- not a git repo
        -- save to variable
        vim.b.git_state = git_state
        -- exit
        return branch_col
    end

    -- get line iterator
    local line_iter = iterlines(output)

    -- process first line (HEAD)
    local line = line_iter()
    if line:find("%(no branch%)") ~= nil then
        -- detached head
        branch_col = 'd'
    else
        -- on branch
        local ahead = line:gsub(".*ahead (%d+).*", "%1")
        local behind = line:gsub(".*behind (%d+).*", "%1")
        -- convert non-numeric to nil
        ahead = tonumber(ahead)
        behind = tonumber(behind)
        if behind ~= nil then
            git_state[1] = '• 󰶹 To pull: ' .. tostring(behind) .. ' '
        end
        if ahead ~= nil then
            git_state[1] = git_state[1] .. '• 󰶼 To push: ' .. tostring(ahead) .. ' '
        end
    end

    -- loop over residual lines (files) &
    -- store number of files
    local git_num = { 0, 0, 0 }
    for l in line_iter do
        branch_col = 'm'
        -- get first char
        local first = l:gsub("^(.).*", "%1")
        if first == '?' then
            -- untracked
            git_num[3] = git_num[3] + 1
        elseif first ~= ' ' then
            -- staged
            git_num[1] = git_num[1] + 1
        end
        -- get second char
        local second = l:gsub("^.(.).*", "%1")
        if second == 'M' then
            -- modified
            git_num[2] = git_num[2] + 1
        end
    end

    -- build output string
    if git_num[1] ~= 0 then
        git_state[2] = '󱣫 Staged: ' .. git_num[1]
    end
    if git_num[2] ~= 0 then
        git_state[3] = '󰷉 Modified: ' .. git_num[2]
    end
    if git_num[3] ~= 0 then
        git_state[4] = ' New: ' .. git_num[3]
    end

    -- save to variable
    vim.b.git_state = git_state
    vim.b.git_show = git_state[1] ~= '' or git_state[2] ~= '' or git_state[3] ~= '' or git_state[4] ~= ''

    old_branch_col = branch_col
end

utils.add_event("UpdateGitStatus", git_status)

local is_git_repo = false

local function check_is_git_repo()
    -- if .git directory exists, update git status
    -- check return value of: git rev-parse --is-inside-work-tree
    local command = "git rev-parse --is-inside-work-tree"
    utils.exec_async(command, function(_, return_val)
        if return_val == 0 then
            is_git_repo = true

            vim.defer_fn(function()
                git_status()

                vim.api.nvim_create_autocmd("BufWritePre", {
                    pattern = "*.*",
                    desc = "Update git status",
                    callback = function()
                        vim.defer_fn(function()
                            git_status()
                        end, 500)
                    end,
                })
            end, 500)
        else
            is_git_repo = false
            git_is_waiting = false
            vim.b.git_state = { '', '', '', '' }
            vim.b.git_show = false
        end
    end, true)
end

check_is_git_repo()

-- update git status on project open
-- couldn't make it work using autocmd and DirChanged event
utils.add_event("ProjectOpened", check_is_git_repo)

local unsaved_buffers_total

local function update_unsaved_buffers()
    unsaved_buffers_total = utils.get_unsaved_buffers_total()

    vim.defer_fn(function()
        update_unsaved_buffers()
    end, 3000)
end

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.*",
    desc = "Update unsaved buffers",
    callback = function()
        vim.defer_fn(function()
            update_unsaved_buffers()
        end, 500)
    end,
})

update_unsaved_buffers()

local function inlay_hints_status()
    local is_enabled = vim.lsp.inlay_hint.is_enabled()

    local label = 'Hints: '

    if not is_enabled then
        return label .. '🫥 Disabled'
    end

    return label .. '🕵️ Enabled '
end

local custom_diagnostics = nil
local hourglass = 1
local bufnr_name_map = {}

local get_spell_count = function()
    return #utils.get_spelunker_bad_list()
end

local function update_diagnostics()
    local all_diagnostics = diagnostics.get_diagnostics({})
    local values = {
        errors = 0,
        warnings = 0,
        info = 0,
    }

    for _, value in ipairs(all_diagnostics) do
        local filename = value.filename

        -- ignore warnings from files outside the project
        -- this can happen when switching between projects
        if filename:find(vim.fn.getcwd(), 1, true) ~= nil then
            if value.severity == vim.diagnostic.severity.ERROR or value.type:upper() == 'ERROR' then
                values.errors = values.errors + 1
            elseif value.severity == vim.diagnostic.severity.WARN or value.type:upper() == 'WARN' then
                values.warnings = values.warnings + 1
            elseif value.severity == vim.diagnostic.severity.INFO or value.type:upper() == 'INFO' then
                values.info = values.info + 1
            end
        end
    end

    local status = lint.is_active() and '󰒲  ' or '󰇘 '

    if lint.is_running() then
        status = HOURGLASSES[hourglass] .. ' '
    end

    local mispellings = get_spell_count()
    local errors = ' Errors: ' .. values.errors
    local warnings = '    Warns: ' .. values.warnings
    local info = '    Info: ' .. values.info
    local mispellings = '    Misspellings: ' .. mispellings

    custom_diagnostics = status .. errors .. warnings .. info .. mispellings

    vim.defer_fn(function()
        hourglass = hourglass + 1

        if hourglass > 3 then
            hourglass = 1
        end

        update_diagnostics()
    end, TIMEOUT)
end

local function get_current_diagnostic()
    local bufnr = 0
    local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
    local opts = { ["lnum"] = line_nr }

    local line_diagnostics = vim.diagnostic.get(bufnr, opts)
    if vim.tbl_isempty(line_diagnostics) then
        return
    end

    local best_diagnostic = nil

    for _, diagnostic in ipairs(line_diagnostics) do
        if
            best_diagnostic == nil or diagnostic.severity < best_diagnostic.severity
        then
            best_diagnostic = diagnostic
        end
    end

    return best_diagnostic
end

local function get_current_diagnostic_value()
    local diagnostic = get_current_diagnostic()

    if not diagnostic or not diagnostic.message then
        return ""
    end

    local message = vim.split(diagnostic.message, "\n")[1]
    local max_width = vim.api.nvim_win_get_width(0) - 35

    local prefix = " Warning: "

    if diagnostic.severity == 1 then
        prefix = " Error: "
    end

    if string.len(message) < max_width then
        return prefix .. ": " .. message
    else
        return string.sub(message, 1, max_width) .. "..."
    end
end

update_diagnostics()

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'gruvbox',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
            statusline = TIMEOUT,
            tabline = TIMEOUT,
            winbar = TIMEOUT,
        }
    },
    sections = {
        lualine_a = {
            { 'mode' },
        },
        lualine_b = {
            {
                'branch',
                color =
                    function()
                        if old_branch_col == 'd' then
                            return { fg = '#BFAAEE' }
                        elseif old_branch_col == 'm' then
                            return { fg = '#f0dbff' }
                        end
                    end

            },
        },
        lualine_c = {
            {
            },
        },
        lualine_x = {
            { inlay_hints_status },
            {
                function()
                    return custom_diagnostics
                end,
                color = {
                    bg = '#aaffff',
                    fg = '#000000',
                },
                separator = {
                    left = '',
                },
            },
        },
        lualine_y = {},
        lualine_z = { 'progress', 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {
            {
                function()
                    -- project status & path
                    local project_icon = projects.is_project() and '󰐯 ' or '󱠎 '
                    return project_icon .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
                end,
                separator = {
                    right = '',
                },
                color = {
                    bg = '#2a2a2a',
                    fg = '#ffffff',
                },
            },
            {
                'filename',
                file_status = true, -- Displays file status (readonly status, modified status)
                newfile_status = false, -- Display new file status (new file means no write after created)
                path = 1, -- 0: Just the filename
                shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                symbols = {
                    modified = '( modified) ', -- Text to show when the file is modified.
                    readonly = '( readonly)', -- Text to show when the file is non-modifiable or readonly.
                    unnamed = '(󰡯 unnamed)', -- Text to show for unnamed buffers.
                    newfile = '( new file)', -- Text to show for newly created file before first write
                },
                color = {
                    bg = '#5f6a8e', -- Background color
                    fg = '#ffffff', -- Text color
                },
                separator = {
                    right = '',
                },
            },
        },
        lualine_b = {
            {
                function()
                    if unsaved_buffers_total == 0 then
                        return ''
                    end

                    return "󱙃  Not saved: " .. unsaved_buffers_total
                end,
                color = { fg = "#B50000", bg = "#e0e0e0" },
                separator = {
                    right = '',
                },
            },
        },
        lualine_x = {
            {
                function()
                    local git_label = '󰊢 Git: '

                    if git_is_waiting then
                        return git_label .. HOURGLASSES[1] .. ' '
                    end

                    if not is_git_repo then
                        return git_label .. 'No git repo'
                    end

                    if vim.b.git_show then
                        return git_label
                    end

                    local action = vim.ceceppa.current_git_action or '  updated '
                    return git_label .. action
                end,
                color = { fg = '#ffffff', bg = '#00575a' },
                separator = {
                    left = '',
                },
                padding = { left = 1, right = 0 },
            },
            {
                -- head status
                "vim.b.git_state[1]",
                color = { fg = '#ffffff', bg = '#00575a' },
                padding = { left = 1, right = 0 },
            },
            {
                -- untracked files
                "vim.b.git_state[4]",
                color = { fg = '#ffffff', bg = '#00575a' },
                padding = { left = 1, right = 1 }
            },
            {
                -- modified files
                "vim.b.git_state[3]",
                color = { fg = '#ffffff', bg = '#00575a' },
                padding = { left = 1, right = 1 }
            },
            {
                -- staged files
                "vim.b.git_state[2]",
                color = { fg = '#ffffff', bg = '#00575a' },
                padding = { left = 1, right = 1 }
            },
        },
        lualine_y = {
            {
                'encoding',
                color = { fg = '#ffffff', bg = '#505a60' },
            },
            {
                'fileformat',
                color = { fg = '#ffffff', bg = '#505a60' },

            },
            {
                'filetype',
                color = { fg = '#ffffff', bg = '#2a2a2a' },
                separator = {
                    left = '',
                },
            }
        },
        lualine_z = {
            -- "os.date('%A, %d %B')", 'data', "require'lsp-status'.status()"
        }
    },
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
