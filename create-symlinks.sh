#!/bin/sh
set -e

reldir=".config/dotfiles"

### sanity checks
if [ "$HOME/$reldir" != "$(pwd)" ]; then
    echo "Please clone this repo to ~/$reldir and run from there."
    exit 1
fi

### functions

confirm() {
    choice=n
    printf "%s [yn] " "$1"

    # allow single-key responses on shells that support it, fall back to POSIX-compatible
    # shellcheck disable=SC2039
    read -n1 -r choice 2> /dev/null || read -r choice
    printf "\n\n"

    case $choice in
        [Yy] )
            ;;
        * )
            exit 1
            ;;
    esac
}

backup_and_symlink() {
    _target="$1"
    _linkprefix="$2"
    _filename="$3"

    printf "%50s  " "$_filename"

    existing="$HOME/$_filename"
    if [ -L "$existing" ] &&
       [ "$_linkprefix/$_filename" = "$(readlink $existing)" ]; then
        printf "[already linked]\n"
        return
    elif [ -h "$existing" ] || [ -w "$existing" ]; then
        mv "$existing" "$backupdir"
        printf "[backup] "
    else
        printf "[      ] "
    fi
    ln -sf "$_linkprefix/$_filename" "$_target"
    printf "[symlink]\n"
    handled=$((handled + 1))
}

link_dotfiles() {
    for file in .??* # make sure we exclude . and .. even in Bourne shell
    do
        # skip .git, .jj and .config
        case "$file" in
            .git )      continue ;;
            .jj )       continue ;;
            .config )   continue ;;
        esac
        backup_and_symlink "$HOME" "$reldir" "$file"
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


### ask for confirmation, except for automated installs
if [ -z "$DOTFILES_AUTO_INSTALL" ]; then
  printf "This script is about to replace your existing dotfiles with symlinks to the ones in %s (DANGEROUS).\n" "$(pwd)"
  confirm "Are you sure?"
fi

### run
mkdir -p "$backupdir"
printf "\nMaking backups in %s.\n" "$backupdir"
link_dotfiles
link_config_subdirs
printf "\n%d symlinks successfully created.\n" $handled
