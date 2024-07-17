local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local utils = require("ceceppa.utils")


local NVIM_COMMANDS_FILE = vim.fn.expand("~/.nvim.commands.json")

local commands_history = {}

local save_command = function(data)
    local json = vim.fn.json_encode(data)

    vim.fn.writefile({ json }, NVIM_COMMANDS_FILE)
end

if vim.fn.filereadable(NVIM_COMMANDS_FILE) == 1 then
    commands_history = vim.fn.json_decode(vim.fn.readfile(vim.fn.expand(NVIM_COMMANDS_FILE)))
else
    save_command(commands_history)
end

local function command_picker()
    pickers.new({}, {
        prompt_title = "Commands",
        finder = finders.new_table {
            results = commands_history,
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            local run_command = function(_, then_callback)
                local selection = action_state.get_selected_entry(prompt_bufnr)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local prompt = picker:_get_prompt()

                actions.close(prompt_bufnr)

                local command_to_run = selection and selection.value or prompt

                if command_to_run and string.len(command_to_run) > 0 then
                    local command = vim.split(command_to_run, " ")[1]
                    local ok = pcall(vim.fn.executable, command)
                    if not ok then
                        vim.notify("Command not found: " .. command, vim.log.levels.ERROR)

                        return
                    end

                    utils.exec_async(command_to_run, then_callback)
                else
                    vim.notify("No command to run", vim.log.levels.ERROR)
                end

                if not selection then
                    table.insert(commands_history, command_to_run)
                    save_command(commands_history)
                end
            end

            local remove_command_from_history = function()
                local selection = action_state.get_selected_entry(prompt_bufnr)

                actions.close(prompt_bufnr)

                for i, command in ipairs(commands_history) do
                    if command == selection.value then
                        table.remove(commands_history, i)
                        save_command(commands_history)

                        print("Command removed")
                        break
                    end
                end

                command_picker()
            end

            local run_command_and_log = function(_)
                run_command(_, function()
                    vim.cmd('ExecAsyncLog')
                end)
            end

            map("i", "<CR>", run_command)
            map("n", "<CR>", run_command)
            map("i", "<S-CR>", run_command_and_log)
            map("n", "<S-CR>", run_command_and_log)
            map("i", "<C-x>", remove_command_from_history)

            return true
        end,
    }):find()
end

vim.api.nvim_create_user_command("ExecAsync", function()
    command_picker()
end, { desc = 'Async command picker / runner', force = true })

vim.api.nvim_set_keymap("n", "<leader>x", ':ExecAsync<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>xl", ':ExecAsyncLog<CR>', { noremap = true, silent = true })
