" Hannu Hartikainen's .vimrc
"
" Modified from code snippets found all over the place...
"
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
  set backupdir=~/.vim/backup
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" load Go support (if $GOROOT is defined) and gofmt after saving
set rtp+=$GOROOT/misc/vim
autocmd BufWritePost *.go :silent Fmt

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")


" my own modifications... guess this'll grow over time

" color scheme
colorscheme wombat

" fonts
if has("gui_running")
    if has("gui_win32")
        set guifont=Consolas:h11:cANSI
    else
        set guifont=Consolas\ 11
    endif
endif

" map <LocalLeader>
"let maplocalleader = ","
"nvm, with US keymap I rather like "\"

" set indentation
set ts=4 sw=4 sts=4 expandtab autoindent

" use mouse
set mouse=a

" split windows "the right way"
set splitbelow splitright

" xml.vim
let xml_use_xhtml=1
let xml_tag_completion_map = "<C-l>"

" python specific
let python_highlight_all=1

" html specific
autocmd FileType xml,html,xhtml,css setlocal ts=2 sw=2 sts=2 et ai
autocmd FileType xml,html,xhtml setlocal foldmethod=marker

" ensure that all omni completions are turned on
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html,xhtml set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

" nicer filename completion
set wildmenu

" minibufexpl.vim
let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplForceSyntaxEnable = 1
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplModSelTarget = 1

" C/C++ include paths
set path+=/usr/include/**
set path+=/usr/local/include/**

""" Vundle configs
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'fholgado/minibufexpl.vim'
Bundle 'ervandew/supertab'
Bundle 'int3/vim-taglist-plus'
