# enable colors (prezto doesn't do this)
autoload -U colors && colors

### my config helper functions
# these are used in local .zshrc variations so don't remove them :)
_add_path() {
    if [ -d "$1" ]; then
        path+="$1"
    fi
}
_prepend_path() {
    if [ -d "$1" ]; then
        path=("$1" $path)
    fi
}
_add_manpath() {
    if [ -d "$1" ]; then
        MANPATH="$MANPATH:$1"
    fi
}
_prepend_manpath() {
    if [ -d "$1" ]; then
        MANPATH="$1:$MANPATH"
    fi
}
_source() {
    if [ -f "$1" ]; then
	    source "$1"
    fi
}


### LOCAL
_source ~/.zshrc-$(hostname -s)


### ZGEN
# for hints about plugins, see https://github.com/unixorn/awesome-zsh-plugins

# start by loading zgen and the oh-my-zsh lib
source ~/.zsh/zgen/zgen.zsh

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    # prezto components
    zgen load sorin-ionescu/prezto modules/directory
    zgen load sorin-ionescu/prezto modules/environment
    zgen load sorin-ionescu/prezto modules/editor
    zgen load sorin-ionescu/prezto modules/history
    zgen load sorin-ionescu/prezto modules/completion

    # i used to have this, but some gnu utils are worse than zsh builtins
    # eg. fzf fails due to features missing in g[ and gprintf
    #zgen load sorin-ionescu/prezto modules/gnu-utility

    # oh-my-zsh: just the stuff needed for prompts
    zgen load robbyrussell/oh-my-zsh lib/git.zsh
    zgen load robbyrussell/oh-my-zsh lib/theme-and-appearance.zsh

    # Code::Stats (my plugin!)
    #zgen load git@gitlab.com:code-stats/code-stats-zsh.git
    zgen load "${HOME}/dev/zsh-codestats"

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    #zgen load caiogondim/bullet-train-oh-my-zsh-theme bullet-train
    zgen load fdv/platypus platypus

    # other plugins
    zgen load zsh-users/zsh-history-substring-search
    zgen load supercrabtree/k
    zgen load zsh-users/zsh-syntax-highlighting

    # save all to init script
    zgen save
fi

# config zsh-history-substring-search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down


### PATH

# prevent duplicates in $PATH
typeset -U path

# add my own ~/bin to $PATH (unless it exists already)
_add_path ~/bin

# add tool-specific directories to $PATH if they exist
_add_path ~/.cabal/bin          # Cabal (Haskell)
_add_path ~/.local/bin          # Stack (Haskell)
_add_path ~/.cargo/bin          # Cargo (Rust)
_add_path ~/.npm-packages/bin   # NPM homedir global installs (Node.js)

# macOS / Homebrew GNU tools
if [[ "$(uname)" == "Darwin" ]]; then
    _use_gnu_from_homebrew() {
        _prepend_path "/usr/local/opt/$1/libexec/gnubin"
        _prepend_manpath "/usr/local/opt/$1/libexec/gnuman"
    }

    # Put GNU tools in front of PATH and MANPATH. Last line becomes first item.
    _use_gnu_from_homebrew gnu-tar
    _use_gnu_from_homebrew gnu-sed
    _use_gnu_from_homebrew coreutils

    unfunction _use_gnu_from_homebrew
fi

### VIM and LESS

# ensure we use (neo)vim if possible
if which nvim > /dev/null; then
    alias vi=nvim
    alias vim=nvim
elif which vim > /dev/null; then
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

    # grotty misbehaves on Fedora 22
    export GROFF_NO_SGR=1
fi

# enable fzf completions; define useful macros
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh

    # fshow - git commit browser (enter for show, ctrl-d for diff, ` toggles sort)
    fshow() {
      local out shas sha q k
      while out=$(
          git log --graph --color=always \
              --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
          fzf --ansi --multi --no-sort --reverse --query="$q" \
              --print-query --expect=ctrl-d --toggle-sort=\`); do
        q=$(head -1 <<< "$out")
        k=$(head -2 <<< "$out" | tail -1)
        shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
        [ -z "$shas" ] && continue
        if [ "$k" = ctrl-d ]; then
          git diff --color=always $shas | less -R
        else
          for sha in $shas; do
            git show --color=always $sha | less -R
          done
        fi
      done
    }
fi


### ASDF (version manager)
_source /usr/local/opt/asdf/asdf.sh

### unset config helpers
unfunction _add_path
unfunction _add_manpath
unfunction _prepend_path
unfunction _prepend_manpath
#unfunction _source

export MANPATH
