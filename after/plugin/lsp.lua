local inlay = require('inlay-hints')
local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

inlay.setup()

lsp.preset("recommended")

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = '',
        warn = '',
        hint = '⚑',
        info = ''
    }
})

lsp.on_attach(function(client)
    was_enabled = vim.lsp.inlay_hint.is_enabled()
    are_inlay_hints_available = are_inlay_hints_available or
        client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint

    local function enable_inlay_hints(is_change_mode)
        local current_buffer_name = vim.fn.bufname(vim.fn.bufnr('%'))

        if current_buffer_name == "" then
            return
        end

        local is_enabled = vim.lsp.inlay_hint.is_enabled()

        if is_enabled then
            return
        end

        local should_enable = true

        if is_change_mode and not was_enabled then
            should_enable = false
        end

        if are_inlay_hints_available and should_enable then
            -- print("🕵️: Enabling inlay_hint")

            local ok, result = pcall(vim.lsp.inlay_hint.enable, true)

            if not ok then
                print("😔: Error enabling inlay_hint", result)
            end

            if is_change_mode then
                was_enabled = true
            end
        end
    end

    local function disable_inlay_hints(is_change_mode)
        local current_buffer_name = vim.fn.bufname(vim.fn.bufnr('%'))

        if current_buffer_name == "" then
            return
        end

        if are_inlay_hints_available then
            vim.lsp.inlay_hint.enable(false)

            if is_change_mode then
                was_enabled = false
            end
        end
    end

    local function toggle_inlay_hints()
        local enabled = vim.lsp.inlay_hint.is_enabled()

        if not enabled then
            enable_inlay_hints()
        else
            disable_inlay_hints()
        end
    end

    -- By default, enable inlay hints for TypeScript and JavaScript only
    local filetype = vim.bo.filetype
    if filetype == 'typescript' or filetype == 'javascript' or filetype == 'typescriptreact' then
        vim.defer_fn(function()
            enable_inlay_hints()
        end, 100)
    end

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = '@: Go to definition' })
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { desc = '@: Show hover' })
    vim.keymap.set("n", "<leader>i", toggle_inlay_hints, { desc = '@: Toggle inlay hints' })
    vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end,
        { desc = '@: Search workspace symbols' })
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, { desc = '@: Open diagnostic float' })
    vim.keymap.set("n", "]e", function() vim.diagnostic.goto_next() end, { desc = '@: Go to next diagnostic/error' })
    vim.keymap.set("n", "[e", function() vim.diagnostic.goto_prev() end, { desc = '@: Go to previous diagnostic/error' })
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = '@: Code action' })
    vim.keymap.set("n", "<C-a>", function() vim.lsp.buf.code_action() end, { desc = '@: Code action' })
    vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, { desc = '@: Show references' })
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, { desc = '@: Rename variable' })
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, { desc = '@: Show signature help' })

    -- Insert Mode changed
    vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = { "*:[iI\x16]*" },
        callback = function()
            disable_inlay_hints(true)
        end,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = { "[iI\x16]*:*" },
        callback = function()
            enable_inlay_hints(true)
        end,
    })

    -- Visual mode changed
    vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = { "*:[vV\x16]*" },
        callback = function()
            disable_inlay_hints(true)
        end,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = { "[vV\x16]*:*" },
        callback = function()
            enable_inlay_hints(true)
        end,
    })
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
lsp.capabilities = capabilities

require "lsp_signature".setup({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
        border = "rounded"
    }
})

lspconfig.lua_ls.setup({
    on_attach = function(client, bufnr)
        inlay.on_attach(client, bufnr)
    end,
    settings = {
        Lua = {
            hint = {
                enable = true,
            },
            lens = {
                enable = true,
            },
        },
    }
})

lspconfig.tsserver.setup({
    on_attach = function(c, b)
        inlay.on_attach(c, b)
    end,
    settings = {
        javascript = {
            hint = {
                enable = true
            },
            lens = {
                enable = true,
            },
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
            },
        },
        typescript = {
            hint = {
                enable = true
            },
            lens = {
                enable = true,
            },
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "none", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
            },
        },
    },
})

require 'lspconfig'.phpactor.setup {
    on_attach = on_attach,
    init_options = {
        ["language_server_phpstan.enabled"] = false,
        ["language_server_psalm.enabled"] = false,
    }
}
