return {
    'wbthomason/packer.nvim',

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-ui-select.nvim' },
        }
    },

    { 'nvim-treesitter/nvim-treesitter' },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { { "nvim-lua/plenary.nvim" } }
    },

    'mbbill/undotree',
    'tpope/vim-fugitive',

    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            {
                'neovim/nvim-lspconfig',
                opts = {
                    inlay_hints = { enabled = true },
                },
            },
            {
                'williamboman/mason.nvim',
                build = function()
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
    },

    {
        'rmagatti/auto-session',
        config = function()
            require("auto-session").setup {
            }
        end
    },

    'nvim-treesitter/nvim-treesitter-context',

    'tpope/vim-surround',
    'tpope/vim-repeat',

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        'junegunn/fzf',
        build = function()
            vim.fn['fzf#install']()
        end
    },
    'tpope/vim-commentary',

    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },

    'airblade/vim-gitgutter',
    'HiPhish/rainbow-delimiters.nvim',

    {
        'nvimdev/lspsaga.nvim',
        dependencies = { 'nvim-lspconfig' },
        config = function()
            require('lspsaga').setup({})
        end,
    },

    'dense-analysis/ale',

    'eandrju/cellular-automaton.nvim',
    'ray-x/lsp_signature.nvim',

    { 'github/copilot.vim',              branch = 'release' },

    'rcarriga/nvim-notify',

    {
        "kdheepak/lazygit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").load_extension("lazygit")
        end,
    },

    'windwp/nvim-ts-autotag',
    'famiu/bufdelete.nvim',

    {
        'numtostr/comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },

    'jiangmiao/auto-pairs',

    { 'stevearc/dressing.nvim' },

    'windwp/nvim-spectre',

    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup()
        end
    },


    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end
    },

    "yuchanns/phpfmt.nvim",

    {
        "stevearc/aerial.nvim",
        config = function()
            require("aerial").setup()
        end,
    },

    'stephpy/vim-php-cs-fixer',
    {
        "LintaoAmons/bookmarks.nvim",
        config = function()
            require("bookmarks").setup({
                json_db_path = vim.fs.normalize(vim.fn.stdpath("config") .. "/bookmarks.db.json"),
                signs = {
                    mark = { icon = "", color = "grey" },
                },
            })
        end
    },

    {
        'gbprod/phpactor.nvim',
        build = function()
            require("phpactor.handler.update")()
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig"
        },
    },

    'maxmx03/solarized.nvim',
    'stsewd/fzf-checkout.vim',

    {
        'dmmulroy/ts-error-translator.nvim',
        config = function()
            require("ts-error-translator").setup {
            }
        end
    },

    'folke/lazydev.nvim',
    { dir = '~/Projects/tsc.nvim' },
}
