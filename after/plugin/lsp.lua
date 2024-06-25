local ih = require('inlay-hints')
local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")

ih.setup()

lsp.preset("recommended")

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'rust_analyzer',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client)
    enabled = vim.lsp.inlay_hint.is_enabled()
    are_inlay_hints_available = are_inlay_hints_available or client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint

    local function enable_inlay_hints()
        if are_inlay_hints_available then
            -- print("Enabling inlay_hint")

            vim.lsp.inlay_hint.enable(true)

            enabled = true
        end
    end

    local function disable_inlay_hints()
        if are_inlay_hints_available then
            print("Disabling inlay_hint")

            vim.lsp.inlay_hint.enable(false)

            enabled = false
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

    enable_inlay_hints()

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
            disable_inlay_hints()
        end,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = { "[iI\x16]*:*" },
        callback = function()
            enable_inlay_hints()
        end,
    })

    -- Visual mode changed
    vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = { "*:[vV\x16]*" },
        callback = function()
            disable_inlay_hints()
        end,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = { "[vV\x16]*:*" },
        callback = function()
            enable_inlay_hints()
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
        ih.on_attach(client, bufnr)
    end,
    settings = {
        Lua = {
            hint = {
                enable = true,
            },
        },
    }
})

lspconfig.tsserver.setup({
    on_attach = function(c, b)
        ih.on_attach(c, b)
    end,
    settings = {
        javascript = {
            hint = {
                enable = true
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
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "literals", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
            },
        },
    },
})

require 'lspconfig'.grammarly.setup {
    filetypes = { "markdown", "tex", "text", },
    on_attach = on_attach,
    init_options = { clientId = "client_BaDkMgx4X19X9UxxYRCXZo" },
    root_dir = function(fname)
        return require 'lspconfig'.util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end,
    cmd = { "grammarly-languageserver", "--stdio" },
}

require 'lspconfig'.phpactor.setup {
    on_attach = on_attach,
    init_options = {
        ["language_server_phpstan.enabled"] = false,
        ["language_server_psalm.enabled"] = false,
    }
}
