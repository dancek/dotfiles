" Hannu Hartikainen's init.vim / .vimrc.
" Rewritten (greatly simplified) in 2017.
"
" QUICK START:
"   :PlugUpdate | PlugUpgrade

" indentation defaults I like
set softtabstop=4 shiftwidth=4 expandtab autoindent

"""""""""
" PLUGINS
"
" Use vim-plug; see https://github.com/junegunn/vim-plug .
" Note: symlink ~/.config/nvim -> ~/.vim for NeoVim
call plug#begin('~/.vim/plugged')

" basic UI
Plug 'tpope/vim-sensible'
Plug 'junegunn/fzf.vim'         " Note: fzf should be installed globally

Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 1

" language support
Plug 'sheerun/vim-polyglot'     " pretty much every language

" local code-stats-vim instance
Plug '~/dev/code-stats-vim'

call plug#end()
