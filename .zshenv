export EDITOR="vi"
export VISUAL="vi"
export HOST

# locale specific stuff: make everything utf8, use Finnish settings but
# never ever use the Finnish language.
LC_MESSAGES="en_US.UTF-8" # language; I don't want any GB langpacks
LANG="en_US.UTF-8"      # fallback if LC_specific not set
LC_PAPER="fi_FI.UTF-8"   # a4, can't print without this
LC_MEASUREMENT="fi_FI.UTF-8" # metric system
LC_NUMERIC="en_US.UTF-8" # I dislike Finnish notation.
LC_MONETARY="fi_FI.UTF-8" # EUR
LC_TIME="en_US.UTF-8"   # need to figure out iso-8601
LC_CTYPE="fi_FI.UTF-8"  # which characters are letter
LC_COLLATE="fi_FI.UTF-8" # sort order, eg. a" &auml; is after z
LC_NAME="fi_FI.UTF-8"
LC_ADDRESS="fi_FI.UTF-8"
LC_TELEPHONE="fi_FI.UTF-8"

export LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT LC_IDENTIFICATION

export JAVA_TEXT_ENCODING="UTF-8"

umask 022
