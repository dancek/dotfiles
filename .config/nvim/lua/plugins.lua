return require('packer').startup(function()
  -- packer itself
  use 'wbthomason/packer.nvim'
  
  -- theme
  use 'morhetz/gruvbox'

  -- essentials
  use 'tpope/vim-sensible'
  use 'tpope/vim-repeat'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-surround'

  use 'junegunn/vim-easy-align'
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'         -- Note: fzf should be installed globally
  
  use 'sheerun/vim-polyglot'

  use 'vim-airline/vim-airline'

  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end
  }

  use 'https://gitlab.com/code-stats/code-stats-vim.git'

  vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])
end)
