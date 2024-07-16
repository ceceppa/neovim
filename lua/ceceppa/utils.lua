local Job = require 'plenary.job'
local Popup = require 'plenary.popup'

local M = {}
local is_showing_qflist = false

local _latest_output = {}

local function show_qflist(title, output)
    is_showing_qflist = true

    vim.fn.setqflist({}, "r", { title = title, items = output })

    local win = vim.api.nvim_get_current_win()

    vim.cmd("copen")
    pcall(vim.api.nvim_set_current_win, win)
end

local popup_id

local function show_popup(title, output)
    local width = 80
    local height = 20
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

    popup_id = Popup.create(output, {
        title = title,
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        callback = function()
        end,
    })

    local bufnr = vim.api.nvim_win_get_buf(popup_id)
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "q",
        ':fclose<CR>',
        { noremap = true, silent = true }
    )
end


local spinner = { "⣷", "⣯", "⣟", "⡿", "⢿", "⣻", "⣽", "⣾" }

local function format_notification_msg(msg, spinner_idx)
    if spinner_idx == 0 or spinner_idx == nil then
        return string.format(" %s ", msg)
    end

    return string.format(" %s %s ", spinner[spinner_idx], msg)
end

local function show_notification(command, description, is_silent)
    local run_command
    local on_complete
    local notify_record
    local show = not is_silent
    local spinner_idx = 0
    local hide_from_history = false

    run_command = function()
        if not show then
            return
        end

        local options = notify_record and {
            replace = notify_record.id,
            hide_from_history = hide_from_history,
            on_close = function()
                notify_record = nil
            end,
        } or {}

        options.title = command

        notify_record = vim.notify(
            format_notification_msg(description, spinner_idx),
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
        show = false

        if is_silent then
            return
        end

        local options = notify_record and { replace = notify_record.id } or {}

        if level == "error" then
            vim.schedule(function()
                vim.notify(" ❌ " .. description .. " failed: 😭😭😭", "error", options)
            end)
        else
            vim.schedule(function()
                vim.notify(" ✅ " .. description .. " successful: 🎉🎉🎉", nil, options)
            end)
        end
    end

    hide_from_history = false

    run_command()

    return on_complete
end

M.execute_command = function(command, description, args, then_callback, should_return, silent)
    local output = {}

    local on_complete = show_notification(command .. " " .. table.concat(args, ' '), description, silent)
    local should_ignore_error = false

    Job:new({
        command = command,
        args = args,
        on_stdout = function(_, data)
            table.insert(output, data)
        end,
        on_stderr = function(_, data)
            if not string.find(data, "packageManager") and not string.find(data, "Corepack must") then
                table.insert(output, data)
            else
                should_ignore_error = true
            end
        end,
        on_exit = function(_, return_val)
            _latest_output = output

            if should_return then
                then_callback(output)
            else
                if return_val == 0 then
                    on_complete("success")

                    if then_callback then
                        vim.schedule(function()
                            then_callback()
                        end)
                    end

                    if is_showing_qflist then
                        vim.schedule(function()
                            vim.cmd("cclose")
                            is_showing_qflist = false
                        end)
                    end
                else
                    if should_ignore_error then
                        on_complete("success")
                        return
                    end

                    on_complete("error")

                    vim.schedule(function()
                        local formatted_output = should_return and should_return(output) or {}

                        if #formatted_output > 0 then
                            show_qflist(command, formatted_output)
                        else
                            show_popup(command, output)
                        end
                    end)
                end
            end
        end
    }):start()
end

M.exec_async = function(command, then_callback)
    local parts = vim.split(command, " ")

    M.execute_command(parts[1], parts[1], vim.list_slice(parts, 2, #parts), then_callback, nil, false)
end

M.get_unsaved_buffers_total = function()
    local unsaved_buffers = 0

    vim.b.unsaved_buffers = ''

    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        local buffer_name = vim.api.nvim_buf_get_name(buffer)
        if vim.api.nvim_buf_get_option(buffer, "modified") then
            unsaved_buffers = unsaved_buffers + 1
        end
    end

    return unsaved_buffers
end

local event_handlers = {}
M.add_event = function(event, callback)
    if not event_handlers[event] then
        event_handlers[event] = {}
    end

    table.insert(event_handlers[event], callback)
end

M.trigger_event = function(event, ...)
    if not event_handlers[event] then
        return
    end

    for _, callback in ipairs(event_handlers[event]) do
        callback(...)
    end
end

M.get_spelunker_bad_list = function ()
    vim.call('spelunker#cases#reset_case_counter')

    local orig_spelunker_target_min_char_len = vim.g.spelunker_target_min_char_len
    vim.g.spelunker_target_min_char_len = 1

    local window_text_list = vim.call('spelunker#get_buffer#all')
    local spell_bad_list = vim.call('spelunker#spellbad#get_spell_bad_list', window_text_list)

    return spell_bad_list
end


vim.api.nvim_create_user_command("ExecAsyncLog", function()
    show_popup("Latest Async Output", _latest_output)
end, { desc = "Show the latest async output in a popup", force = true })

return M
