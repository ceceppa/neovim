local TIMEOUT = 3000

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
local latest_check_datetime = nil
local old_branch_col = nil

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
        git_state[2] = '• 󱣫 Staged: ' .. git_num[1]
    end
    if git_num[2] ~= 0 then
        git_state[3] = '• 󰷉 Modified: ' .. git_num[2]
    end
    if git_num[3] ~= 0 then
        git_state[4] = '•  New: ' .. git_num[3]
    end

    -- save to variable
    vim.b.git_state = git_state
    vim.b.git_show = git_state[1] ~= '' or git_state[2] ~= '' or git_state[3] ~= '' or git_state[4] ~= ''

    old_branch_col = branch_col
end

local is_git_repo = false

-- if .git directory exists, update git status
if vim.fn.isdirectory('.git') == 1 then
    is_git_repo = true
    git_status()

    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.*",
        desc = "Update git status",
        callback = function()
            git_status()
        end,
    })
else
    vim.b.git_state = { '', '', '', '' }
    vim.b.git_show = false
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

local function inlay_hints_status()
    local is_enabled = vim.lsp.inlay_hint.is_enabled()

    local label = 'Inlay hints: '

    if not is_enabled then
        return label .. '🫥 Disabled'
    end

    return label .. '🕵️ Enabled '
end

local custom_diagnostics = nil
local HOURGLASSES = { '', '', '' }
local hourglass = 1

local function update_diagnostics()
    local vim_diagnostic = vim.diagnostic.get()
    local values = {
        errors = 0,
        warnings = 0,
    }

    for _, value in ipairs(vim_diagnostic) do
        if value.severity == 1 then
            values.errors = values.errors + 1
        elseif value.severity == 2 then
            values.warnings = values.warnings + 1
        end
    end

    for _, value in ipairs(vim.ceceppa.errors.lint) do
        if value.type:upper() == 'ERROR' then
            values.errors = values.errors + 1
        else
            values.warnings = values.warnings + 1
        end
    end

    for _, value in ipairs(vim.ceceppa.errors.tsc) do
        if value.type:upper() == 'ERROR' then
            values.errors = values.errors + 1
        else
            values.warnings = values.warnings + 1
        end
    end

    local status = '  '

    if vim.ceceppa.errors.running then
        status = HOURGLASSES[hourglass] .. ' '
    end

    custom_diagnostics = status .. ' Errors: ' .. values.errors .. '    Warns: ' .. values.warnings

    vim.defer_fn(function()
        hourglass = hourglass + 1

        if hourglass > 3 then
            hourglass = 1
        end

        update_diagnostics()
    end, TIMEOUT)
end

update_diagnostics()

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
            statusline = TIMEOUT,
            tabline = TIMEOUT,
            winbar = TIMEOUT,
        }
    },
    sections = {
        lualine_a = { 'mode' },
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
        },
        lualine_x = {
            {
                inlay_hints_status,
                color = { fg = '#ffffff', bg = '#2a2a2a' },
                separator = {
                    left = '',
                },
            },
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
            }
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
                    -- path
                    return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
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
                    if not is_git_repo then
                        return 'No git repo'
                    end

                    if vim.b.git_show then
                        return 'Git'
                    end

                    return 'Git:   '
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
