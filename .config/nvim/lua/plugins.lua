return require('packer').startup(function()
  -- packer itself
  use 'wbthomason/packer.nvim'
  
  -- essentials
  use 'tpope/vim-sensible'
  use 'tpope/vim-repeat'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-surround'

  use 'junegunn/vim-easy-align'
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'         -- Note: fzf should be installed globally
  
  use 'sheerun/vim-polyglot'

  -- UI enhancements
  use 'morhetz/gruvbox'
  use {
    'vim-airline/vim-airline',
    config = function()
      vim.g['airline_powerline_fonts'] = 1
      vim.g['airline_section_x'] = vim.call('airline#section#create_right',
        {'tagbar', 'filetype', '%{CodeStatsXp()}'})
    end
  }
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end
  }

  use 'https://gitlab.com/code-stats/code-stats-vim.git'

  vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])
end)
