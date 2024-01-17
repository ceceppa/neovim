local Job = require'plenary.job'
local Popup = require'plenary.popup'

local spinner = {"⣷", "⣯", "⣟", "⡿", "⢿", "⣻", "⣽", "⣾"}

local function format_notification_msg(msg, spinner_idx)
    if spinner_idx == 0 or spinner_idx == nil then
        return string.format(" %s ", msg)
    end

    return string.format(" %s %s ", spinner[spinner_idx], msg)
end

local function show_git_notification(command)
    local run_command
    local on_complete
    local notify_record
    local show_notification = true
    local spinner_idx = 0
    local hide_from_history = false

    run_command = function()
        if not show_notification then
            return
        end

        local options = notify_record and { replace = notify_record.id, hide_from_history = hide_from_history } or {}

        options.title = 'git ' .. command

        notify_record = vim.notify(
            format_notification_msg( command .. 'ing', spinner_idx),
            nil,
            options
        )

        hide_from_history = true

        spinner_idx = spinner_idx + 1

        if spinner_idx > #spinner then
            spinner_idx = 1
        end

        vim.defer_fn(run_command, 125)
    end

    on_complete = function(level)
        show_notification = false

        local options = notify_record and { replace = notify_record.id } or {}

        if level == "error" then
            vim.schedule(function()
                vim.notify(" ❌ " .. command .. " failed: 😭😭😭", "error", options)
            end)
        else
            vim.schedule(function()
                vim.notify(" ✅ " .. command .. " successful: 🎉🎉🎉", nil, options)
            end)
        end
    end

    hide_from_history = false

    run_command()

    return on_complete
end

local popup_id

function close_git_popup(_, sel)
    vim.api.nvim_win_close(popup_id, true)
end


function display_git_output(output)
    local width = 80
    local height = 20
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

    popup_id = Popup.create(output, {
        title = "Git Output",
        highlight = "GitOutputWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        callback = function()
        end,
    })

    local bufnr = vim.api.nvim_win_get_buf(popup_id)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua close_git_popup()<CR>", { silent=false })
end

local function execute_git_command(description, args, then_callback)
    local output = {}

    local on_complete = show_git_notification(description)

    Job:new({
        command = 'git',
        args = args,
        on_stdout = function(_, data)
            table.insert(output, data)
        end,
        on_stderr = function(_, data)
            table.insert(output, data)
        end,
        on_exit = function(j, return_val)
            if return_val == 0 then
                on_complete("success")
                if then_callback then
                    then_callback()
                end
            else
                on_complete("error")

                vim.schedule(function()
                    display_git_output(output)
                end)
            end
        end
    }):start()
end

vim.keymap.set('n', '<leader>gw', ':G blame<CR>', { desc = 'Git praise' });

function git_pull()
    execute_git_command('pull', {'pull'})
end

function git_push()
    execute_git_command('push', {'push'})
end

vim.keymap.set('n', '<leader>gi', function() git_pull() end, { desc = 'Git pull' });
vim.keymap.set('n', '<leader>go', function() git_push() end, { desc = 'Git push' });
vim.keymap.set('n', '<leader>gu', function() execute_git_command('pull origin/main', {'pull', 'origin', 'main'}) end, { desc = 'Git pull origin main' });
vim.keymap.set('n', '<leader>gn', ':G checkout -b ', { desc = 'Git checkout new branch' });
vim.keymap.set('n', '<leader>gd', ':GitGutterDiff<cr>', { desc = 'Git diff' });
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Git status' });
vim.keymap.set('n', '<leader>gf', function() execute_git_command('fetch', {'fetch', '-a'}) end, { desc = 'Git fetch' });
vim.keymap.set('n', '<leader>gm', function() 
    execute_git_command('checkout main', {'checkout', 'main'}, function()
        git_pull()
    end)
end, { desc = 'Git checkout main' });
vim.keymap.set('n', '<leader>gv', ':Gvdiffsplit!<CR>', { desc = 'Git diff' });

vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'Open LazyGit' });
vim.keymap.set('n', '<leader>gh', ':LazyGitFilterCurrentFile<CR>', { desc = 'Git file history' });
vim.keymap.set('n', '<leader>gl', ':LazyGitFilter<CR>', { desc = 'Git history' });

vim.keymap.set('n', '<leader>gc', ':Telescope git_commits<CR>', { desc = 'Git commits' });
vim.keymap.set('n', '<leader>gb', ':Telescope git_branches<CR>', { desc = 'Git branches' });

vim.keymap.set('n', '<leader>gx', ':Telescope git_stash<CR>', { desc = 'Git branches' });

function git_add_all_and_commit()
  local input = vim.fn.input("Enter the commit message: ")

  if string.len(input) == 0 then
    return
  end

  execute_git_command("adding all commit", { 'commit', '-am', input }, 
  function()
    git_push()
  end)
end

vim.keymap.set('n', '<leader>g.', [[<Cmd>lua git_add_all_and_commit()<CR>]], { desc = 'Git add all and commit' });


local function maybe_write_and_quit()
    local current_buffer_name = vim.fn.bufname(vim.fn.bufnr('%'))

    if current_buffer_name ~= "COMMIT_EDITMSG" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-o>:wq<CR>', true, true, true), 'n', true)

        git_push()
    end
end

vim.keymap.set('i', '<C-;>', function ()
    maybe_write_and_quit()
end, { desc = 'Git message: Write & quit' });


