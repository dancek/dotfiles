# load optional local config
if test -f "$HOME/.fishrc-local"
    source "$HOME/.fishrc-local"
end

# PATH
fish_add_path --path "$HOME/bin"
fish_add_path --path "$HOME/.config/dotfiles/bin"

# nvim
if type -q nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    abbr --add vi nvim
end

