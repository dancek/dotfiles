source ~/.zsh/helpers.zsh

# enable colors (prezto doesn't do this)
autoload -Uz colors && colors

### LOCAL
__source ~/.zshrc-$(hostname -s)


### ZSH CONFIG

# git aliases
zstyle ':completion:*:*:git:*' user-commands \
    'delete-merged-branches' \
    'tree'


### ZGEN
# for hints about plugins, see https://github.com/unixorn/awesome-zsh-plugins

# start by loading zgen
source ~/.zsh/zgen/zgen.zsh

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    # prezto config
    zgen prezto '*:*' color true
    zgen prezto utility safe-ops false  # things like rm=rm -i
    zgen prezto git:alias skip yes
    zgen prezto prompt theme sorin

    # prezto components
    zgen prezto
    zgen prezto environment
    zgen prezto utility
    zgen prezto directory
    zgen prezto editor
    zgen prezto history
    zgen prezto completion
    zgen prezto git
    zgen prezto spectrum

    # i used to have this, but some gnu utils are worse than zsh builtins
    # eg. fzf fails due to features missing in g[ and gprintf
    #zgen load sorin-ionescu/prezto modules/gnu-utility

    # Code::Stats (my plugin!)
    zgen load https://gitlab.com/code-stats/code-stats-zsh.git
    #zgen load "${HOME}/dev/code-stats-zsh"

    # prezto modules that need to be loaded last (and configs)
    zgen prezto history-substring-search
    zgen prezto syntax-highlighting
    zgen prezto prompt

    # ZLE vi mode bindings
    zgen load softmoth/zsh-vim-mode

    # save all to init script
    zgen save
fi

# config zsh-history-substring-search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down


### CUSTOM CONFIG

# vi mode
KEYTIMEOUT=40
bindkey -v
bindkey -rpM viins '\e\e'
bindkey -M viins '\e\e' vi-cmd-mode

# avoid `zsh: no matches found: HEAD^`
unsetopt nomatch

# report CPU time and memory used for processes that last over 5 seconds
REPORTTIME=5
TIMEFMT="$fg_bold[white]::: $fg[green]%*U user $fg_bold[white]| $fg[cyan]%*S system $fg_bold[white]| $fg[yellow]%P cpu $fg_bold[white]| $fg[magenta]%*E total $fg_bold[white]| $fg[red]%MkB $reset_color"


### PATH

# prevent duplicates in $PATH
typeset -U path

# add my own ~/bin to $PATH (unless it exists already)
__add_path ~/bin

# add tool-specific directories to $PATH if they exist
__add_path ~/.cabal/bin          # Cabal (Haskell)
__add_path ~/.local/bin          # Stack (Haskell)
__add_path ~/.cargo/bin          # Cargo (Rust)
__add_path ~/.npm-packages/bin   # NPM homedir global installs (Node.js)

# macOS / Homebrew GNU tools
if [[ "$(uname)" == "Darwin" ]]; then
    __use_gnu_from_homebrew() {
        __prepend_path "/usr/local/opt/$1/libexec/gnubin"
        __prepend_manpath "/usr/local/opt/$1/libexec/gnuman"
    }

    # Put GNU tools in front of PATH and MANPATH. Last line becomes first item.
    __use_gnu_from_homebrew make
    __use_gnu_from_homebrew gnu-tar
    __use_gnu_from_homebrew gnu-sed
    __use_gnu_from_homebrew coreutils

    # remove git-completion.zsh; see https://github.com/Homebrew/homebrew-core/pull/52324
    __rm /usr/local/share/zsh/site-functions/_git

    unfunction __use_gnu_from_homebrew
fi

### TOOLS

# $PAGER: less with some options
if __cmd less; then
    export PAGER=less
    export LESS="-FKMRqX"
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

# enable fzf completions; define useful macros
if __cmd fzf; then
    __source ~/.fzf.zsh
    __source /usr/share/fzf/key-bindings.zsh

    if __cmd fd; then
        export FZF_DEFAULT_COMMAND='fd --type f'
    fi

    fzf-completion-notrigger() {
        FZF_COMPLETION_TRIGGER="" fzf-completion
    }
    zle -N fzf-completion-notrigger
    bindkey '^ ' fzf-completion-notrigger

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


# utils shipped with zsh
autoload -Uz zmv zcalc


# asdf (version manager)
__source /usr/local/opt/asdf/asdf.sh


### ALIASES

__alias l exa
__alias vi nvim

# git
__alias gr git-revise
__alias ger git-review
alias grr="git remote update && git rebase gerrit/master && git review --yes --no-topic"

# default to python3
__alias python python3
__alias pip pip3

# mosh: use the most common locale
alias mosh="LC_ALL=en_US.UTF-8 mosh"

# docker
docker-here() { docker run --rm --interactive --tty --volume "$(pwd)":/here --workdir /here "$1" bash }
docker-wtf() { docker run --rm --interactive --tty $(docker build --quiet --file="$1" "$(mktemp -d)") bash }
alias docker-cleanup="docker system prune --volumes"

# rust
alias rust-musl-builder='docker run --rm -it -v "$(pwd)":/home/rust/src ekidd/rust-musl-builder'

# clojure utils
if __cmd clojure; then
    alias rebel='clojure -Sdeps "{:deps {com.bhauman/rebel-readline {:git/url \"https://github.com/razum2um/rebel-readline.git\" :sha \"33866bf89633b0df5acd4c67ca74f75f3069f139\" :deps/root \"rebel-readline\"}}}" -m rebel-readline.main'
fi


# directory aliases
hash -d dotfiles=~/.config/dotfiles

### unset config helpers
__unload_helpers


export MANPATH

# When developing completions, uncomment this
#autoload -U compinit && compinit -D
