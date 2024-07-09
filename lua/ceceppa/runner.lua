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

function ceceppa_command_picker()
    pickers.new({}, {
        prompt_title = "Commands",
        finder = finders.new_table {
            results = commands_history,
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            local run_command = function()
                local selection = action_state.get_selected_entry(prompt_bufnr)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local prompt = picker:_get_prompt()

                actions.close(prompt_bufnr)

                local command_to_run = selection and selection.value or prompt

                if not selection then
                    table.insert(commands_history, command_to_run)
                    save_command(commands_history)
                end

                if command_to_run and string.len(command_to_run) > 0 then
                    utils.exec_async(command_to_run)
                else
                    vim.notify("No command to run", vim.log.levels.ERROR)
                end
            end

            local remove_command_from_history = function()
                local selection = action_state.get_selected_entry(prompt_bufnr)

                for i, command in ipairs(commands_history) do
                    if command == selection.value then
                        table.remove(commands_history, i)
                        save_command(commands_history)

                        print("Command removed")
                        break
                    end
                end
            end

            map("i", "<CR>", run_command)
            map("n", "<CR>", run_command)
            map("i", "<C-x>", remove_command_from_history)

            return true
        end,
    }):find()
end

vim.api.nvim_set_keymap("n", "<leader>x", '<cmd>lua ceceppa_command_picker()<CR>', { noremap = true, silent = true })
