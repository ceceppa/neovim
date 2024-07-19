local utils = require('ceceppa.utils')

function display_git_output(output)
    utils.show_popup("Git output", output)
end

local function execute_git_command(description, args, then_callback)
    vim.ceceppa.current_git_action = description

    utils.execute_command('git', description, args, function()
        if then_callback then
            then_callback()
        end

        utils.trigger_event('UpdateGitStatus')
        vim.ceceppa.current_git_action = nil
    end)
end

function get_commit_message()
    local prompt = "Prepend: ! = Force push | ~ = Push with no verify | ? = Push with no verify and force push"
    local input = vim.fn.input(prompt .. "\nEnter the commit message: ")
    local original_input = input

    if string.len(input) == 0 then
        return nil
    end

    if input:sub(1, 1) == '!' or input:sub(1, 1) == '~' or input:sub(1, 1) == '?' then
        input = input:sub(2)
    end

    return { input, original_input }
end

local function get_push_params(input)
    local git_params = { 'push' }

    if not input then
        return git_params
    end

    if input:sub(1, 1) == '!' then
        table.insert(git_params, '--force')
    elseif input:sub(1, 1) == '~' then
        table.insert(git_params, '--no-verify')
    elseif input:sub(1, 1) == '?' then
        table.insert(git_params, '--no-verify')
        table.insert(git_params, '--force')
    end

    return git_params
end

vim.keymap.set('n', '<leader>gw', ':G blame<CR>', { desc = '@: Git praise' });

function git_pull(description, args)
    args = args or {}
    description = description or 'pull'

    local pull_command = { 'pull' }

    for _, arg in ipairs(args) do
        table.insert(pull_command, arg)
    end

    execute_git_command(description, pull_command, function()
        -- if package.json exists
        if vim.fn.filereadable('package.json') == 1 then
            utils.execute_command(vim.ceceppa.package_manager, 'install', { 'install' })
        end
    end)
end

function git_push(input)
    local push_params = get_push_params(input)

    execute_git_command('push', push_params)
end

vim.keymap.set('n', '<leader>gi', function() git_pull() end, { desc = '@: Git pull' });
vim.keymap.set('n', '<leader>go', function() git_push() end, { desc = '@: Git push' });
vim.keymap.set('n', '<leader>gO', function() git_push('~') end, { desc = '@: Git push --no-verify' });
vim.keymap.set('n', '<leader>gF', function() git_push('?') end, { desc = '@: Git push --force --no-verify' });
vim.keymap.set('n', '<leader>gu', function()
        git_pull('pull origin/main', { 'origin', 'main' })
    end,
    { desc = '@: Git pull origin main' });
vim.keymap.set('n', '<leader>gn', ':G checkout -b ', { desc = '@: Git checkout new branch' });
vim.keymap.set('n', '<leader>gd', ':GitGutterDiff<cr>', { desc = '@: Git diff' });
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = '@: Git status' });
vim.keymap.set('n', '<leader>gf', function() execute_git_command('fetch', { 'fetch', '-a' }) end,
    { desc = '@: Git fetch' });
vim.keymap.set('n', '<leader>gm', function()
    execute_git_command('checkout main', { 'checkout', 'main' }, function()
        git_pull()
    end)
end, { desc = '@: Git checkout main' });
vim.keymap.set('n', '<leader>gv', ':Gvdiffsplit!<CR>', { desc = '@: Git diff' });

vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = '@: Open LazyGit' });
vim.keymap.set('n', '<leader>gh', ':LazyGitFilterCurrentFile<CR>', { desc = '@: Git file history' });
vim.keymap.set('n', '<leader>gl', ':LazyGitFilter<CR>', { desc = '@: Git history' });
vim.keymap.set('n', '<leader>gr', function()
    local command = [[!git remote -v | head -n 1 | awk -F "@" '{print $2}' | awk -F " " '{print $1}' | sed 's/:/\//g' | sed 's/.git//g' | awk '{print "http://"$1}' | xargs open]]
    vim.cmd(command)
end, { desc = '@: Git open remote repository in Browser' });

vim.keymap.set('n', '<leader>gc', ':Telescope git_commits<CR>', { desc = '@: Git commits' });

function git_fetch_and_branches()
    print('Git branches: Waiting for fetching...')

    execute_git_command('fetch', { 'fetch', '-a' }, function()
        vim.cmd('Telescope git_branches')
    end)
end

vim.keymap.set('n', '<leader>gb', function() git_fetch_and_branches() end, { desc = '@: Git branches' });

vim.keymap.set('n', '<leader>gsl', ':Telescope git_stash<CR>', { desc = '@: Git stash' });

function git_add_all_and_commit()
    local input = get_commit_message()

    if not input then
        return
    end


    execute_git_command("adding all commit", { 'commit', '-am', input[1] },
        function()
            git_push(input[2])
        end)
end

vim.keymap.set('n', '<leader>g.', [[<Cmd>lua git_add_all_and_commit()<CR>]], { desc = '@: Git add all and commit' });

local function maybe_write_and_close_window()
    local current_buffer_name = vim.fn.bufname(vim.fn.bufnr('%'))

    if string.find(current_buffer_name, "fugitive") then
        local input = get_commit_message()

        if not input then
            return
        end

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-o>:wq<CR>', true, true, true), 'n', true)

        execute_git_command("commit with message", { 'commit', '-m', input[1] },
            function()
                git_push(input[2])
            end)
    end
end

local function git_stash_with_name()
    local input = vim.fn.input("Stash name: ")

    if string.len(input) == 0 then
        return
    end

    execute_git_command("stash with name", { 'stash', 'push', '-m', input })
end


vim.keymap.set('n', '<C-;>', function()
    maybe_write_and_close_window()
end, { desc = '@: Git: Write commit message and push' });

vim.keymap.set('n', '<leader>gss', function()
    git_stash_with_name()
end, { desc = '@: Git: stash with name' });
