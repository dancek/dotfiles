### my config helper functions
# these are used in local .zshrc variations so don't remove them :)
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
__source() {
    if [ -f "$1" ]; then
        source "$1"
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
        compdef $1=${@:2} 2&> /dev/null
    fi
}
