local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

ensure_packer()

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-ui-select.nvim' },
        }
    }

    use('nvim-treesitter/nvim-treesitter', {
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update.prefer_git = true

            ts_update()
        end
    })

    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { { "nvim-lua/plenary.nvim" } }
    }

    use('tpope/vim-fugitive')

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            {
                'neovim/nvim-lspconfig',
                opts = {
                    inlay_hints = { enabled = true },
                },
            },
            {
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'simrat39/inlay-hints.nvim' }
        }
    }

    use {
        'rmagatti/auto-session',
        config = function()
            require("auto-session").setup {
            }
        end
    }

    use('nvim-treesitter/nvim-treesitter-context')

    use('tpope/vim-surround')
    use('tpope/vim-repeat')

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons' }
    }
    use {
        'junegunn/fzf',
        run = function()
            vim.fn['fzf#install']()
        end
    }
    use('airblade/vim-gitgutter')
    use('HiPhish/rainbow-delimiters.nvim')

    use({
        'nvimdev/lspsaga.nvim',
        after = 'nvim-lspconfig',
        config = function()
            require('lspsaga').setup({})
        end,
    })

    use('dense-analysis/ale')

    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    use('eandrju/cellular-automaton.nvim')
    use('ray-x/lsp_signature.nvim')

    use { 'github/copilot.vim', branch = 'release' }

    use 'rcarriga/nvim-notify'
    use 'windwp/nvim-ts-autotag'
    use 'famiu/bufdelete.nvim'

    use {
        'numtostr/comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use 'jiangmiao/auto-pairs'

    use { 'stevearc/dressing.nvim' }

    use 'windwp/nvim-spectre'

    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup()
        end
    }

    -- Local
    use {
        '~/Projects/tsc.nvim',
        requires = {
            { 'rcarriga/nvim-notify' },
        }
    }

    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end
    }

    use "yuchanns/phpfmt.nvim"


    use({
        "stevearc/aerial.nvim",
        config = function()
            require("aerial").setup()
        end,
    })

    use 'stephpy/vim-php-cs-fixer'

    use {
        "LintaoAmons/bookmarks.nvim",
        tag = "v0.5.3",
        config = function()
            require("bookmarks").setup({
                json_db_path = vim.fs.normalize(vim.fn.stdpath("config") .. "/bookmarks.db.json"),
                signs = {
                    mark = { icon = "", color = "grey" },
                },
            })
        end
    }

    use {
        'gbprod/phpactor.nvim',
        run = function()
            require("phpactor.handler.update")()
        end,
        require = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig"
        },
    }

    use {
        'dmmulroy/ts-error-translator.nvim',
        config = function()
            require("ts-error-translator").setup {
            }
        end
    }

    use {
        'nvim-tree/nvim-tree.lua',
        requires = { 'nvim-tree/nvim-web-devicons' }
    }

    use "mbbill/undotree"
    use 'justinmk/vim-sneak'
    use 'morhetz/gruvbox'
    use 'kdheepak/lazygit.nvim'
    use 'kamykn/spelunker.vim'

    vim.keymap.set('n', '<leader>ps', ':so<CR>:PackerSync<CR>')
end)
