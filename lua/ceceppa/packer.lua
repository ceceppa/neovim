vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.1',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({ 'rose-pine/neovim', as = 'rose-pine' })
  use { 'embark-theme/vim', as = 'embark' }

  use( 'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use( 'nvim-treesitter/playground' )

  use('ThePrimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')

  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v2.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},             -- Required
		  {                                      -- Optional
		  'williamboman/mason.nvim',
		  run = function()
			  pcall(vim.cmd, 'MasonUpdate')
		  end,
	  },
	  {'williamboman/mason-lspconfig.nvim'}, -- Optional

	  -- Autocompletion
	  {'hrsh7th/nvim-cmp'},     -- Required
	  {'hrsh7th/cmp-nvim-lsp'}, -- Required
	  {'L3MON4D3/LuaSnip'},     -- Required
     }
  }

  use('eandrju/cellular-automaton.nvim')

  use {
      'rmagatti/auto-session',
      config = function()
          require("auto-session").setup {
              log_level = "error",
          }
      end
  }

  use('vim-airline/vim-airline-themes')

  use('nvim-treesitter/nvim-treesitter-context')

  use({
      "glepnir/lspsaga.nvim",
      opt = true,
      branch = "main",
      event = "LspAttach",
      config = function()
          require("lspsaga").setup({})
      end,
      requires = {
          {"nvim-tree/nvim-web-devicons"},
          --Please make sure you install markdown and markdown_inline parser
          {"nvim-treesitter/nvim-treesitter"}
      }
  })

  use('tpope/vim-surround')
  use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use('nvim-tree/nvim-web-devicons')
  use('dense-analysis/ale')
  use('mrjones2014/nvim-ts-rainbow')
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
  use('SirVer/ultisnips')
  use('honza/vim-snippets')
  use('airblade/vim-gitgutter')
  use('joaohkfaria/vim-jest-snippets')


  use('nvim-lua/plenary.nvim')
  use('andythigpen/nvim-coverage')

  use {
      "folke/which-key.nvim",
      config = function()
          vim.o.timeout = true
          vim.o.timeoutlen = 300
          require("which-key").setup {
              -- your configuration comes here
              -- or leave it empty to use the default settings
              -- refer to the configuration section below
          }
      end
  }

  use {
      'folke/trouble.nvim',
      config = function() 
      end
  }

  use('kshenoy/vim-signature')
  use('nvim-telescope/telescope-ui-select.nvim')

end)

