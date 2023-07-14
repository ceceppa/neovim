vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { 
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-ui-select.nvim' },
        }
    }

    use({ 'rose-pine/neovim', as = 'rose-pine' })
    use { 'embark-theme/vim', as = 'embark' }

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-treesitter/playground')

    use('ThePrimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {
                    'neovim/nvim-lspconfig',
            }, -- Required
            {                  -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

              -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' }, 
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },
        }
    }
    use {
        'rmagatti/auto-session',
        config = function()
            require("auto-session").setup {
            }
        end
    }

    use('vim-airline/vim-airline-themes')

    use('nvim-treesitter/nvim-treesitter-context')

    use('tpope/vim-surround')
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use('ervandew/supertab')
    use('stsewd/fzf-checkout.vim')
    use {
        'junegunn/fzf',
        run = function()
            vim.fn['fzf#install']()
        end
    }
    use('tomtom/tcomment_vim')
    use('nvim-tree/nvim-tree.lua')
    use('airblade/vim-gitgutter')

    use {
        'folke/trouble.nvim',
        config = function()
        end
    }

    use('kshenoy/vim-signature')
    use('HiPhish/rainbow-delimiters.nvim')

    use ({
        'nvimdev/lspsaga.nvim',
        after = 'nvim-lspconfig',
        config = function()
            require('lspsaga').setup({})
        end,
    })

    use('dense-analysis/ale')

    vim.keymap.set('n', '<leader>ps', ':so<CR>:PackerSync<CR>')
end)


