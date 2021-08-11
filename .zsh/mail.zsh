notmuch=$HOME/bin/notmuch

alias nn="$notmuch new"
alias ni="$notmuch search tag:inbox and tag:important"
alias ns="$notmuch show --format=pretty"
alias nsi="$notmuch show --format=pretty --color tag:inbox and tag:important | less"

nr() {
    draft=$(mktemp $HOME/draft-XXXX)
    $notmuch reply $1 > "$draft" || return
    nvim -c 'set filetype=mail' "$draft" || return
    cat "$draft"
    echo
    echo "Press ENTER to send (Ctrl-C to cancel)"
    read || return
    cat "$draft" | msmtp -t || return
    rm "$draft"
}
