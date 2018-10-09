#!/bin/sh
set -e

### sanity checks
if [ "$HOME/.config/dotfiles" != "$(pwd)" ]; then
    echo "Please clone this repo to ~/.config/dotfiles and run from there."
    exit 1
fi

### functions

backup_and_symlink() {
    _target="$1"
    _linkprefix="$2"
    _filename="$3"

    printf "%50s  " "$_filename"

    existing="$HOME/$_filename"
    if [ -h "$existing" ] || [ -w "$existing" ]; then
        mv "$existing" "$backupdir"
        printf "[backup] "
    else
        printf "[      ] "
    fi
    ln -s "$_linkprefix/$_filename" "$_target"
    printf "[symlink]\n"
    handled=$((handled + 1))
}

link_dotfiles() {
    for file in .??* # make sure we exclude . and .. even in Bourne shell
    do
        # skip .git and .config
        case "$file" in
            .git )      continue ;;
            .config )   continue ;;
        esac
        backup_and_symlink "$HOME" ".config/dotfiles" "$file"
    done
}

link_config_subdirs() {
    # note: dotfiles inside .config are intentionally not handled
    for file in .config/*
    do
        case "$file" in
            dotfiles )      continue ;;
            .config/\* )    continue ;;
        esac
        backup_and_symlink "$HOME/.config" "dotfiles" "$file"
    done
}


### global vars
backupdir="backup/$(date +%Y-%m-%d_%H%M)"
handled=0


### ask for confirmation
printf "This script is about to replace your existing dotfiles with symlinks to the ones in %s (DANGEROUS). Are you sure? [yn] " "$(pwd)"
read -r choice

case $choice in
    [Yy] )
        # go for it!
        mkdir -p "$backupdir"
        printf "\nMaking backups in %s.\n" "$backupdir"
        link_dotfiles
        link_config_subdirs
        printf "\n%d symlinks successfully created.\n" $handled
        ;;
    * )
        exit 1
        ;;
esac
