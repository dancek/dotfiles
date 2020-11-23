# macOS and friends are so unfriendly with the stuff they run for me
setopt noglobalrcs

export EDITOR="nvim"
export VISUAL="nvim"
export HOST

# NOTE: this probably only works on linux. shit.
export LANG="en_DK.UTF-8"

export JAVA_TEXT_ENCODING="UTF-8"

export RUBYOPT="rubygems"

export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"

umask 022

# npm: install globally in homedir
export NPM_CONFIG_PREFIX="$HOME/.npm-packages"
