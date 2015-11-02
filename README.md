These are some of my dotfiles. Nothing fancy.

I created this setup with the following in mind:
 * version control
 * backups
 * a way to update my dotfiles on different machines
 * option not to have a git repository in my $HOME

Cloning (read-only) to a new place works like this:

    git clone git://github.com/dancek/dotfiles.git ~/.config/dotfiles
    cd ~/.config/dotfiles
    ./create-symlinks.sh
    # Vundle is setup as a git submodule
    git submodule init
    git submodule update

(If the directory is something else than ~/.config/dotfiles, you need to tell that to create-symlinks.sh)
