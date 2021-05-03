### my config helper functions
# these are used in local .zshrc variations so don't remove them :)

# source that checks existence
__source() {
    if [ -f "$1" ]; then
        source "$1"
    fi
}


# path helpers: append by default, only override existing (prepend) when sure

__add_path() {
    if [ -d "$1" ]; then
        path+="$1"
    fi
}

__prepend_path() {
    if [ -d "$1" ]; then
        path=("$1" $path)
    fi
}

__add_manpath() {
    if [ -d "$1" ]; then
        MANPATH="$MANPATH:$1"
    fi
}

__prepend_manpath() {
    if [ -d "$1" ]; then
        MANPATH="$1:$MANPATH"
    fi
}

# soft delete for unwanted files
__rm() {
    if [ -f "$1" ]; then
        echo "WARN: some idiot has added $1. PROTIP:"
        echo "  rm \"$1\""
    fi
}


# usage:
# if __cmd less; then ... fi
__cmd() {
    which $1 > /dev/null
}

__alias() {
    if __cmd $2; then
        alias $1=${@:2}
        compdef $1=${@:2} &> /dev/null
    fi
}


# unloader for all helpers
__unload_helpers() {
    unfunction __source
    unfunction __add_path
    unfunction __add_manpath
    unfunction __prepend_path
    unfunction __prepend_manpath
    unfunction __rm
    unfunction __cmd
    unfunction __alias
}
