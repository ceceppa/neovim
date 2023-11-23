local Job = require'plenary.job'
local Popup = require'plenary.popup'

local show_notification = false
local notify_record
local hide_from_history = false
local spinner_idx = 0
local spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

local function format_notification_msg(msg, spinner_idx)
    if spinner_idx == 0 or spinner_idx == nil then
        return string.format(" %s ", msg)
    end

    return string.format(" %s %s ", spinner[spinner_idx], msg)
end

local function get_notify_options(...)
  local overrides = {}

  for _, opts in ipairs({ ... }) do
    for key, value in pairs(opts) do
      overrides[key] = value
    end
  end

  return vim.tbl_deep_extend("force", {}, DEFAULT_NOTIFY_OPTIONS, overrides)
end


local function show_git_notification(command)
    local run_command

    run_command = function()
        if not show_notification then
            return
        end

        notify_record = vim.notify(
            format_notification_msg(command, spinner_idx),
            nil,
            notify_record and { replace = notify_record.id, hide_from_history = hide_from_history }
        )

        hide_from_history = true

        spinner_idx = spinner_idx + 1

        if spinner_idx > #spinner then
            spinner_idx = 1
        end

        vim.defer_fn(run_command, 125)
    end

    spinner_idx = 0
    hide_from_history = false

    run_command()
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

local function execute_git_command(description, args)
    local output = {}

    show_notification = true

    show_git_notification("Git " .. description .. "...")

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
            show_notification = false

            if return_val == 0 then
                vim.notify(" ✅ Git " .. description .. " successful: 🎉🎉🎉", "info", { replace = notify_record.id })
            else
                vim.notify(" ❌ Git " .. description .. " failed: 😭😭😭", "error", { replace = notify_record.id })

                vim.schedule(function()
                    display_git_output(output)
                end)
            end
        end
    }):start()
end

vim.keymap.set('n', '<leader>gw', ':G blame<CR>', { desc = 'Git praise' });
vim.keymap.set('n', '<leader>gi', function() execute_git_command('pull', {'pull'}) end, { desc = 'Git pull' });
vim.keymap.set('n', '<leader>go', function() execute_git_command('push', {'push'}) end, { desc = 'Git push' });
vim.keymap.set('n', '<leader>gu', function() execute_git_command('pull origin/main', {'pull', 'origin', 'main'}) end, { desc = 'Git pull origin main' });
vim.keymap.set('n', '<leader>gn', ':G checkout -b ', { desc = 'Git checkout new branch' });
vim.keymap.set('n', '<leader>gd', ':GitGutterDiff<cr>', { desc = 'Git diff' });
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Git status' });
vim.keymap.set('n', '<leader>gf', function() execute_git_command('fetch', {'fetch', '-a'}) end, { desc = 'Git fetch' });
vim.keymap.set('n', '<leader>gv', ':Gvdiffsplit!<CR>', { desc = 'Git diff' });
