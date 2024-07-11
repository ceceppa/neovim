-- Dead simple project management for neovim
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local utils = require('ceceppa.utils')

local NVIM_PROJECTS_FILE = vim.fn.expand("~/.nvim.projects.json")

local projects = {}

local save_projects = function(data)
    local json = vim.fn.json_encode(data)

    vim.fn.writefile({ json }, NVIM_PROJECTS_FILE)
end

if vim.fn.filereadable(NVIM_PROJECTS_FILE) == 1 then
    projects = vim.fn.json_decode(vim.fn.readfile(vim.fn.expand(NVIM_PROJECTS_FILE)))
else
    save_projects(projects)
end

function ceceppa_project_picker()
    pickers.new({}, {
        prompt_title = "Projects",
        finder = finders.new_table {
            results = projects,
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            local open_project = function()
                actions.close(prompt_bufnr)

                local selection = action_state.get_selected_entry(prompt_bufnr)

                if not selection then
                    return
                end

                local open_buffers= utils.get_unsaved_buffers_total()

                if open_buffers > 0 then
                    vim.notify("  You have unsaved buffers", "warn", { title = "Projects" })

                    return
                end

                local auto_session = require("auto-session")
                auto_session.SaveSession()

                vim.cmd("cd " .. selection.value)

                -- Restore session and remove all buffers that are not in the project
                vim.defer_fn(function()
                    local auto_session = require("auto-session")

                    auto_session.RestoreSession()

                    local all_buffers = vim.fn.getbufinfo({ buflisted = 1 })

                    for _, buffer in ipairs(all_buffers) do
                        local path = vim.fn.bufname(buffer.bufnr)
                        local first_char = string.sub(path, 1, 1)

                        if first_char == "/" then
                            vim.cmd("bdelete " .. buffer.bufnr)
                        end
                    end
                end, 100)
            end

            local remove_project = function()
                local selection = action_state.get_selected_entry(prompt_bufnr)
                actions.close(prompt_bufnr)

                for i, project in ipairs(projects) do
                    if project == selection.value then
                        table.remove(projects, i)
                        save_projects(projects)

                        print("Project removed")
                        break
                    end
                end
            end

            map("i", "<CR>", open_project)
            map("n", "<CR>", open_project)
            map("i", "<C-x>", remove_project)

            return true
        end,
    }):find()
end

function ceceppa_project_add()
    local exists = false
    local current_path = vim.fn.getcwd()

    for _, project in ipairs(projects) do
        if project == current_path then
            exists = true
            break
        end
    end

    if not exists then
        table.insert(projects, current_path)
        save_projects(projects)

        vim.notify(" Project added", nil, { title = "Projects" })
    else
        vim.notify(" Project already exists", "warn", { title = "Projects" })
    end
end

vim.api.nvim_set_keymap("n", "<leader>pp", '<cmd>lua ceceppa_project_picker()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>pa", '<cmd>lua ceceppa_project_add()<CR>', { noremap = true, silent = true })
