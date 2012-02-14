#!/bin/sh
set -e

# a backup function
make_backups() {
    mkdir -p backup
    echo Making backups in `pwd`/backup...
    for file in .??* # make sure we exclude . and .. even in Bourne shell
    do
        if [ x"$file" != x".git" ]; then    # don't touch .git
            existing=$HOME/$file
            if [ -w $existing ]; then
                mv $existing backup/
            fi
        fi
    done
}

# the actual work is done here, all the rest is just safeguards
make_symlinks() {
    for file in .??* # make sure we exclude . and .. even in Bourne shell
    do
        if [ x"$file" != x".git" ]; then    # don't touch .git
            ln -s $linkprefix/$file $HOME
        fi
    done
}

# set link prefix from first argument with a default
linkprefix=${1:-.config/dotfiles}

# check $linkprefix is legit
if [ ! -d $HOME/$linkprefix ] || [ ! -r $HOME/$linkprefix ]
then
    echo "$HOME/$linkprefix doesn't seem to be a readable directory. Please supply a relative path inside $HOME as the sole argument to this script."
    exit 2
fi

# ask for confirmation
echo "This script is about to replace your existing dotfiles with symlinks to the ones in $linkprefix (DANGEROUS). Are you sure? [yn] "
read choice

case $choice in
    [Yy]* )
        # go for it!
        make_backups
        make_symlinks
        ;;
    * )
        exit 1
        ;;
esac