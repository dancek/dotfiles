# macOS and friends are so unfriendly with the stuff they run for me
setopt noglobalrcs

export EDITOR="nvim"
export VISUAL="nvim"
export HOST

# locale: UTF-8 with standards except ISO8601 :(
export LANG="en_IE.UTF-8"

export JAVA_TEXT_ENCODING="UTF-8"

export RUBYOPT="rubygems"

export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"

umask 022

# homebrew etc. add libraries in /usr/local
export CPATH="$CPATH:/usr/local/include"
export LIBRARY_PATH="$LIBRARY_PATH:/usr/local/lib"
