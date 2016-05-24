# enable colors (prezto doesn't do this)
autoload -U colors && colors


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

    # other plugins
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-history-substring-search
    zgen load supercrabtree/k

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    #zgen load caiogondim/bullet-train-oh-my-zsh-theme bullet-train
    zgen load fdv/platypus platypus

    # save all to init script
    zgen save
fi

# config zsh-history-substring-search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down


### LOCAL

if [ -r ~/.zshrc-`hostname -s` ]; then
    . ~/.zshrc-`hostname -s`
fi


### PATH

# add my own ~/bin to $PATH (unless it exists already)
echo $PATH | grep ~/bin > /dev/null || PATH=$PATH:~/bin

# add tool-specific directories to $PATH if they exist

# Haskell
if [ -d ~/.cabal/bin ]; then
    PATH=$PATH:~/.cabal/bin
fi

# Rust
if [ -d ~/.cargo/bin ]; then
    PATH=$PATH:~/.cargo/bin
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

    # grotty misbehaves on Fedora 22
    export GROFF_NO_SGR=1
fi

# if MacVim is installed, allow starting it with 'gvim'
if [ -x /Applications/MacVim.app/Contents/MacOS/Vim ]; then
    alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'
fi

# enable fzf completions; define useful macros
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
    
    # fh - repeat history
    fh() {
      print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
    }

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
