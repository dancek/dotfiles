" Hannu Hartikainen's init.vim / .vimrc.
" Rewritten in 2017.
"
" QUICK START:
"   :PlugUpdate | PlugUpgrade

set nocompatible

" indentation defaults I like
set tabstop=4 shiftwidth=4 expandtab autoindent

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

call plug#end()
