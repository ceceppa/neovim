local inlay = require('inlay-hints')
local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "󰥔",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls",
        "cssls",
        "html",
        "jsonls",
        "rust_analyzer",
        "tsserver",
        "vimls",
        "yamlls",
        "phpactor",
        "eslint"
    },
})

inlay.setup()

lsp.preset("recommended")

local INLAY_STATUESES = {
    ignore = "ignore",
    reEnable = "reEnable",
}

local inlay_status = INLAY_STATUESES.ignore

lsp.on_attach(function(client)
    local function enable_inlay_hints(is_triggered_by_autocmd)
        local current_buffer_name = vim.fn.bufname(vim.fn.bufnr('%'))

        if current_buffer_name == "" then
            return
        end

        local is_enabled = vim.lsp.inlay_hint.is_enabled()

        if is_enabled then
            return
        end

        local should_enable = true

        if is_triggered_by_autocmd and inlay_status == INLAY_STATUESES.reEnable then
            should_enable = false
        end

        if should_enable then
            local ok = pcall(vim.lsp.inlay_hint.enable, true)

            if not ok then
                vim.notify("😔: Error enabling inlay_hint", "error", { title = "LSP" })
            end

            if is_triggered_by_autocmd then
                inlay_status = INLAY_STATUESES.ignore
            end
        end
    end

    local function disable_inlay_hints(is_triggered_by_autocmd)
        local current_buffer_name = vim.fn.bufname(vim.fn.bufnr('%'))

        if current_buffer_name == "" then
            return
        end

        vim.lsp.inlay_hint.enable(false)

        if is_triggered_by_autocmd then
            inlay_status = INLAY_STATUESES.reEnable
        end
    end

    local function toggle_inlay_hints()
        local enabled = vim.lsp.inlay_hint.is_enabled()
        print("Inlay hints ", enabled, " -> ", not enabled)

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
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    float = {
        border = "single",
        format = function(diagnostic)
            return string.format(
                "%s (%s) [%s]",
                diagnostic.message,
                diagnostic.source,
                diagnostic.code or diagnostic.user_data.lsp.code
            )
        end,
    },
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
                includeInlayParameterNameHints = "none", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
            },
        },
    },
})

lspconfig.eslint.setup({
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    settings = {
        workingDirectory = {
            mode = "auto"
        },
        format = { enable = true },
        lint = { enable = true },
    },
})

require 'lspconfig'.phpactor.setup {
    on_attach = on_attach,
    init_options = {
        ["language_server_phpstan.enabled"] = false,
        ["language_server_psalm.enabled"] = false,
    }
}
lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = ' ',
        warn = ' ',
        hint = '⚑ ',
        info = ' '
    }
})
