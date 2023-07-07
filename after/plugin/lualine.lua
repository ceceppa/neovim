-- -- try git status

-- helper function to loop over string lines
-- copied from https://stackoverflow.com/a/19329565
local function iterlines(s)
        if s:sub(-1)~="\n" then s=s.."\n" end
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
        vim.b.git_state = {'', '', '', ''}
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
    vim.b.git_state = {'', '', ''}
    -- get & check file directory
    file_dir = find_dir(vim.fn.expand("%:p:h"))
    -- check fugitive etc.
    if vim.b.git_state[1] ~= "" then
        return 'u'
    end
    -- capture git status call
    local cmd = "git -C " .. file_dir .. " status --porcelain -b 2> /dev/null"
    local handle = assert(io.popen(cmd, 'r'), '')
    -- output contains empty line at end (removed by iterlines)
    local output = assert(handle:read('*a'))
    -- close io
    handle:close()

    local git_state = {'', '', '', ''}
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
    local git_num = {0, 0, 0}
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
        git_state[2] = '  ' .. git_num[1]
    end
    if git_num[2] ~= 0 then
        git_state[3] = '󰷉 ' .. git_num[2]
    end
    if git_num[3] ~= 0 then
        git_state[4] = ' ' .. git_num[3]
    end
    
    -- save to variable
    vim.b.git_state = git_state
    
    return branch_col
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
      lualine_a = {'mode'},
      lualine_b = {
          {
              'branch',
              color = 
              function(section)
                  local gs = git_status()
                  if gs == 'd' then
                      return { fg = '#BFAAEE' }
                  elseif gs == 'm' then
                      return { fg = '#f0dbff' }
                  end
              end
          },
          {
              -- head status
              "vim.b.git_state[1]",
              color = function(section)
                  if vim.b.git_state[1]:find("^ %w+ $") ~= nil then
                      return { fg = '#F49B55' }
                  end
              end,
              padding = { left = 1, right = 1 }
          },
          { 
              -- staged files
              "vim.b.git_state[2]",
              color = { fg = '#A4C379' },
              padding = { left = 1, right = 1 }
          },
          {
              -- modified files
              "vim.b.git_state[3]",
              color = { fg = '#f0dbff' },
              padding = { left = 1, right = 1 }
          },
          {
              -- untracked files
              "vim.b.git_state[4]",
              color = { fg = '#F6B11E' },
              padding = { left = 1, right = 1 }
          },
      },
      lualine_c = {
          {
              'filename',
              file_status = true,      -- Displays file status (readonly status, modified status)
              newfile_status = false,  -- Display new file status (new file means no write after created)
              path = 1,                -- 0: Just the filename
              -- 1: Relative path
              -- 2: Absolute path
              -- 3: Absolute path, with tilde as the home directory
              -- 4: Filename and parent dir, with tilde as the home directory

              shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
              -- for other components. (terrible name, any suggestions?)
              symbols = {
                  modified = ' ',      -- Text to show when the file is modified.
                  readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
                  unnamed = '[No Name]', -- Text to show for unnamed buffers.
                  newfile = '[New]',     -- Text to show for newly created file before first write
              },
          }
      },
      lualine_x = {
          'diagnostics',
          {
              'diff',
              colored = true, 
              diff_color = {
                  added    = {fg='#73ff00'},   
                  modified = {fg='#f0dbff'},   
                  removed  = {fg='#ffa8a8'},
              },
              symbols = {added = ' ', modified = '󰤀 ', removed = '󰐓 '}, 
          },
          'filetype',
      },
      lualine_y = {'progress'},
      lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
