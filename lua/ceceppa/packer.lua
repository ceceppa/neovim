local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()


return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-ui-select.nvim' },
        }
    }

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { { "nvim-lua/plenary.nvim" } }
    }

    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
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
    use('tpope/vim-commentary')

    use {
        'nvim-tree/nvim-tree.lua',
        requires = { 'nvim-tree/nvim-web-devicons' }
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

    use({
        "kdheepak/lazygit.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").load_extension("lazygit")
        end,
    })

    use({ 'catppuccin/nvim', as = "catppuccin" })

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

    vim.keymap.set('n', '<leader>ps', ':so<CR>:PackerSync<CR>')

    use({
        "stevearc/aerial.nvim",
        config = function()
            require("aerial").setup()
        end,
    })

    use 'stephpy/vim-php-cs-fixer'
    use {
        "LintaoAmons/bookmarks.nvim",
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
        build = function()
            require("phpactor.handler.update")()
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig"
        },
    }

    use 'maxmx03/solarized.nvim'
    use 'stsewd/fzf-checkout.vim'

    use {
        'dmmulroy/ts-error-translator.nvim',
        config = function()
            require("ts-error-translator").setup {
            }
        end
    }
end)
