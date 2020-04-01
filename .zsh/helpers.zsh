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
# usage:
# if _cmd less; then ... fi
_cmd() {
    which $1 > /dev/null
}
_alias() {
    if _cmd $2; then
        alias $1=${@:2}
        compdef $1=${@:2} 2&> /dev/null
    fi
}
