-- -- try git status

-- helper function to loop over string lines
-- copied from https://stackoverflow.com/a/19329565
local function iterlines(s)
    if s:sub(-1) ~= "\n" then s = s .. "\n" end
    return s:gmatch("(.-)\n")
end

-- find directory
function find_dir(d)
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
    local ok, err, code = os.rename(d, d)
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
local function git_status()
    vim.b.git_state = { '', '', '' }
    -- get & check file directory
    file_dir = find_dir(vim.fn.expand("%:p:h"))
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
            git_state[1] = '󰶹 ' .. tostring(behind) .. ' '
        end
        if ahead ~= nil then
            git_state[1] = git_state[1] .. '󰶼 ' .. tostring(ahead) .. ' '
        end
    end

    -- loop over residual lines (files) &
    -- store number of files
    local git_num = { 0, 0, 0 }
    for line in line_iter do
        branch_col = 'm'
        -- get first char
        local first = line:gsub("^(.).*", "%1")
        if first == '?' then
            -- untracked
            git_num[3] = git_num[3] + 1
        elseif first ~= ' ' then
            -- staged
            git_num[1] = git_num[1] + 1
        end
        -- get second char
        local second = line:gsub("^.(.).*", "%1")
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
        git_state[4] = ' Untracked: ' .. git_num[3]
    end

    -- save to variable
    vim.b.git_state = git_state

    return branch_col
end

local function unsaved_buffers()
    local unsaved_buffers = 0

    vim.b.unsaved_buffers = ''

    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(buffer, "modified") then
            unsaved_buffers = unsaved_buffers + 1
        end
    end

    if unsaved_buffers == 0 then
        return ''
    end

    return "󱙃  Not saved: " .. unsaved_buffers
end

local function get_current_diagnostic()
    bufnr = 0
    line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
    opts = { ["lnum"] = line_nr }

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

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'everforest',
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
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            {
                'branch',
                color =
                    function()
                        local gs = git_status()
                        if gs == 'd' then
                            return { fg = '#BFAAEE' }
                        elseif gs == 'm' then
                            return { fg = '#f0dbff' }
                        end
                    end
            },
        },
        lualine_c = {
            {
                get_current_diagnostic_value,
            },
        },
        lualine_x = {
            {
                function()
                    return 'Diagnostics'
                end,
                separator = {
                    right = '',
                },
            },
            {
                'diagnostics',
                      sections = { 'error', 'warn', 'info', 'hint' },
                 symbols = {error = ' Error(s):', warn = '•   Warning(s): ', info = '•  Info: ', hint = '•  Hint: '},
             },
        },
        lualine_y = {
            {
                function()
                    return 'Lines changed:'
                end,
                separator = {
                    right = '',
                },
            },
            {
                'diff',
                colored = true,
                diff_color = {
                    added    = { fg = '#73ff00' },
                    modified = { fg = '#f0dbff' },
                    removed  = { fg = '#ffa8a8' },
                },
                symbols = { added = '󰐒  Added: ', modified = '• 󰤀 Modified: ', removed = '• 󰐓 Removed: ' },
            },
        },
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
                    return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
                end,
                separator = {
                    right = '',
                },
            },
            {
                'filename',
                file_status = true,     -- Displays file status (readonly status, modified status)
                newfile_status = false, -- Display new file status (new file means no write after created)
                path = 1,               -- 0: Just the filename
                -- 1: Relative path
                -- 2: Absolute path
                -- 3: Absolute path, with tilde as the home directory
                -- 4: Filename and parent dir, with tilde as the home directory

                shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                -- for other components. (terrible name, any suggestions?)
                symbols = {
                    modified = '( modified) ', -- Text to show when the file is modified.
                    readonly = '( readonly)', -- Text to show when the file is non-modifiable or readonly.
                    unnamed = '(󰡯 unnamed)', -- Text to show for unnamed buffers.
                    newfile = '( new file)', -- Text to show for newly created file before first write
                },
                color = {
                    bg = '#5f6a8e', -- Background color
                    fg = '#fff', -- Text color
                },
                separator = {
                    right = '',
                },
            }
        },
        lualine_b = {
            {
                unsaved_buffers,
                color = { fg = "#B50000", bg = "#e0e0e0" },
                separator = {
                    right = '',
                },
            },
        },
        lualine_x = {
            {
                function()
                    return 'Git'
                end,
                color = { fg = '#f00', bg = '#44475a' },
                separator = {
                    left = '',
                },
            },
            {
                -- head status
                "vim.b.git_state[1]",
                color = function()
                    if vim.b and vim.b.git_state[1]:find("^ %w+ $") ~= nil then
                        return { fg = '#F49B55', bg = '#44475a' }
                    end
                end,
                padding = { left = 1, right = 0 },
            },
            {
                -- untracked files
                "vim.b.git_state[4]",
                color = { fg = '#F6B11E', bg = '#44475a' },
                padding = { left = 1, right = 1 }
            },
            {
                -- modified files
                "vim.b.git_state[3]",
                color = { fg = '#f0dbff', bg = '#44475a' },
                padding = { left = 1, right = 1 }
            },
            {
                -- staged files
                "vim.b.git_state[2]",
                color = { fg = '#A4C379', bg = '#44475a' },
                padding = { left = 1, right = 1 }
            },
        },
        lualine_y = {
            'encoding', 'fileformat', 'filetype',
        },
        lualine_z = {
            "os.date('%A, %d %B')", 'data', "require'lsp-status'.status()"
        }
    },
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
