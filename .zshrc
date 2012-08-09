# read local config if it exists
if [ -r ~/.zshrc-`hostname -s` ]; then
    . ~/.zshrc-`hostname -s`
fi

# some HUT specific stuff
if hostname | grep .hut.fi; then
    export NOHUTCCALIASES="true"
    [ -e /etc/default.hut/shell/zshrc-system-default ] && . /etc/default.hut/shell/zshrc-system-default
fi

# add my own ~/bin to $PATH (unless it exists already)
echo $PATH | grep ~/bin > /dev/null || export PATH=$PATH:~/bin

# setup ls colors if terminal supports colors
autoload zsh/terminfo
if [ -n "$terminfo[colors]" ]; then
    which gdircolors > /dev/null && eval `gdircolors -b ~/.dircolors`
    which dircolors > /dev/null && eval `dircolors -b ~/.dircolors`
    # don't re-alias ls (so aliasing gls in .zshrc-`hostname` works)
    alias ls > /dev/null || alias ls="ls --color"
fi

# set some zsh options
setopt auto_pushd pushd_ignore_dups	# do pushd on cd
unsetopt ignoreeof	# allow ctrl-d to logout
setopt c_bases	# print hex like 0xFF instead of 16#FF

# setup prompt
. ~/.zshprompt

# setup history
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt append_history hist_ignore_dups extended_history hist_ignore_space hist_verify

# "fun" stuff
REPORTTIME=30
#WATCH=notme
WATCHFMT='%n %a %l from %m at %T.'

# ensure we use vim if possible
if which vim > /dev/null; then
    alias vi=vim
    # use vim as a less-like pager, see https://github.com/huyz/less.vim
    if [ -x ~/.vim/macros/m ]; then
        export PATH=$PATH:~/.vim/macros
    fi
fi

# set $PAGER to m if available, otherwise less (with some options)
if which m > /dev/null; then
    export PAGER=m
elif which less > /dev/null; then
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

# use emacs mode for zsh line editor
bindkey -e

# do some magic to fix keyboard
bindkey '^[[3~' delete-char
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

case $TERM in (xterm*)
    bindkey '\e[H' beginning-of-line
    bindkey '\e[F' end-of-line
esac


# The following lines were added by compinstall

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' menu select=1
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle :compinstall filename '~/.zshrc'

autoload -U compinit
compinit
# End of lines added by compinstall


