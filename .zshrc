### ZSH4HUMANS

zstyle ':z4h:'        auto-update            'no'
zstyle ':z4h:bindkey' keyboard               'pc'
zstyle ':z4h:'        term-shell-integration 'yes'
zstyle ':z4h:'        prompt-at-bottom       'no'
zstyle ':z4h:'        start-tmux             'no'

# disable all command wrapping (hacky)
typeset -gi _z4h_wrap_ssh=2
typeset -gi _z4h_wrap_sudo=2
typeset -gi _z4h_wrap_docker=2

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# completions
#zstyle ':z4h:fzf-complete' recurse-dirs 'no'

zstyle ':completion:*:ssh:argument-1:'       tag-order  hosts users
zstyle ':completion:*:scp:argument-rest:'    tag-order  hosts files users
zstyle ':completion:*:(ssh|scp|rdp):*:hosts' hosts


# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

### ZSH COMPONENTS

autoload -Uz zmv zcalc


### CUSTOM ZSH CONFIG

# helpers we'll use later in this file
source ~/.zsh/helpers.zsh

# local customizations
__source ~/.zshrc-$(hostname -s)


# git aliases
zstyle ':completion:*:*:git:*' user-commands \
    'delete-merged-branches' \
    'tree'


# vi mode (TODO: fix with z4h)
KEYTIMEOUT=40
# bindkey -v
# bindkey '^I' z4h-fzf-complete
# bindkey -rpM viins '\e\e'
# bindkey -M viins '\e\e' vi-cmd-mode

# directories
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

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
__add_path ~/go/bin              # Go

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

# nvim
if __cmd nvim; then
    export EDITOR="nvim"
    export VISUAL="nvim"
fi

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

if __cmd broot; then
    # This script was automatically generated by the broot program
    # More information can be found in https://github.com/Canop/broot
    # This function starts broot and executes the command
    # it produces, if any.
    # It's needed because some shell commands, like `cd`,
    # have no useful effect if executed in a subshell.
    function br {
        f=$(mktemp)
        (
            set +e
            broot --outcmd "$f" "$@"
            code=$?
            if [ "$code" != 0 ]; then
                rm -f "$f"
                exit "$code"
            fi
        )
        code=$?
        if [ "$code" != 0 ]; then
            return "$code"
        fi
        d=$(<"$f")
        rm -f "$f"
        eval "$d"
    }
fi

if __cmd zoxide; then
    eval "$(zoxide init zsh)"
fi


# asdf (version manager)
__source /usr/local/opt/asdf/asdf.sh


### ENV VARIABLES

export LANG="en_DK.UTF-8"
export MANPATH

# java
export JAVA_TEXT_ENCODING="UTF-8"
export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"


### ALIASES

compdef _files l

# mail commands
if __cmd notmuch; then
    source ~/.zsh/mail.zsh
fi

__alias ls lsd
__alias ll ls -al

__alias vi nvim
__alias netstat ss

# sudo: refresh timeout on every use
#alias sudo="sudo -v && sudo"

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
docker-here() {
    docker run --rm --interactive --tty --volume "$(pwd)":/here --workdir /here "$1" bash
}
docker-wtf() {
    docker run --rm --interactive --tty --volume "$(pwd)":/here --workdir /here $(docker build --quiet --file="$1" "$(mktemp -d)") bash
}
alias docker-cleanup="docker system prune --volumes"

# rust
alias rust-musl-builder='docker run --rm -it -v "$(pwd)":/home/rust/src ekidd/rust-musl-builder'

# clojure utils
if __cmd clojure; then
    alias rebel='clojure -Sdeps "{:deps {com.bhauman/rebel-readline {:git/url \"https://github.com/razum2um/rebel-readline.git\" :sha \"33866bf89633b0df5acd4c67ca74f75f3069f139\" :deps/root \"rebel-readline\"}}}" -m rebel-readline.main'
fi

# gif utils
parrotify() {
    convert -bordercolor transparent -border 1x1 -delay 4x100 -dispose background "$1" -duplicate 9 -distort SRT '0,0 1 0 %[fx:-30*sin(2*pi*t/10)],%[fx:10-10*cos((2*pi*t-3)/10)]' -shave 1x1 "$(echo $1 | sed 's/\..*/-parrot.gif/')"
}
foreverify() {
    convert -delay 8x100 -dispose background "$@" -duplicate 17 -distort SRT '%[fx:20*t]' "$(echo $1 | sed 's/\..*/-forever.gif/')"
}

# device tree
show_dtb() {
    dtc -I dtb -O dts "$@" | bat -l c
}

# password generator
alias pw="head -c24 < /dev/urandom | base64"

# directory aliases
hash -d dotfiles=~/.config/dotfiles

### unset config helpers
__unload_helpers


# When developing completions, uncomment this
#autoload -U compinit && compinit -D

# sccs shadows this so add manually
compdef _gnu_generic delta

