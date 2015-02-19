### ANTIGEN

# start by loading antigen and the oh-my-zsh lib
source ~/.zsh/antigen/antigen.zsh
antigen use oh-my-zsh

# read local config if it exists
if [ -r ~/.zshrc-`hostname -s` ]; then
    . ~/.zshrc-`hostname -s`
fi

# tell antigen that we're done
antigen apply


### PATH

# add my own ~/bin to $PATH (unless it exists already)
echo $PATH | grep ~/bin > /dev/null || PATH=$PATH:~/bin

# add ~/.cabal/bin to $PATH if it exists
if [ -d ~/.cabal/bin ]; then
    PATH=$PATH:~/.cabal/bin
fi

export PATH


### VIM and LESS

# ensure we use vim if possible
if which vim > /dev/null; then
    alias vi=vim
fi

# set $PAGER to less (with some options)
if which less > /dev/null; then
    export PAGER=less
    export LESS="-mqR"
    export LESS_TERMCAP_mb=$'\E[01;31m'
    export LESS_TERMCAP_md=$'\E[01;31m'
    export LESS_TERMCAP_me=$'\E[0m'
    export LESS_TERMCAP_se=$'\E[0m'
    export LESS_TERMCAP_so=$'\E[01;44;33m'
    export LESS_TERMCAP_ue=$'\E[0m'
    export LESS_TERMCAP_us=$'\E[01;32m'
    which lesspipe > /dev/null && export LESSOPEN="| lesspipe %s"
    export LESSCHARSET="utf-8"
fi

# if MacVim is installed, allow starting it with 'gvim'
if [ -x /Applications/MacVim.app/Contents/MacOS/Vim ]; then
    alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'
fi
