#!/bin/sh

usage() {
    echo "Usage: $0 -s <shell> [-d <dotfiles_dir>]"
    echo "  -s  Shell to configure: 'bash' or 'zsh'"
    echo "  -d  Dotfiles location (default: \$HOME/.dotfiles)"
    exit 1
}

DOTFILES_LOCATION="$HOME/.dotfiles"
SHELL_CHOICE=""

while getopts "s:d:" opt; do
    case $opt in
        s) SHELL_CHOICE="$OPTARG" ;;
        d) DOTFILES_LOCATION="$OPTARG" ;;
        *) usage ;;
    esac
done

if [ -z "$SHELL_CHOICE" ]; then
    echo "Error: shell is required"
    usage
fi

case $SHELL_CHOICE in
    bash|zsh) ;;
    *) echo "Error: unsupported shell '$SHELL_CHOICE' (use 'bash' or 'zsh')"; usage ;;
esac

echo "Using shell: $SHELL_CHOICE"
echo "Using dotfiles location: $DOTFILES_LOCATION"

# Remove any previous config
[ -f $HOME/.gitconfig ]   && rm $HOME/.gitconfig
[ -f $HOME/.profile ]     && rm $HOME/.profile
[ -f $HOME/.bashrc ]      && cp $HOME/.bashrc $HOME/.bashrc.bkp && rm $HOME/.bashrc
[ -f $HOME/.zshrc ]       && cp $HOME/.zshrc $HOME/.zshrc.bkp && rm $HOME/.zshrc
[ -f $HOME/.vimrc ]       && rm $HOME/.vimrc
[ -f $HOME/.tmux.conf ]   && rm $HOME/.tmux.conf
[ -f $HOME/.vim ]         && rm -r "$HOME/.vim"

# link vim & tmux config
ln -s "${DOTFILES_LOCATION}/.vim" "$HOME/.vim"
ln -s "${DOTFILES_LOCATION}/.vimrc" "$HOME/.vimrc"
ln -s "${DOTFILES_LOCATION}/.tmux.conf" "$HOME/.tmux.conf"
ln -s "${DOTFILES_LOCATION}/.gitconfig" "$HOME/.gitconfig"

# Run bash- or zsh specific init scripts
$SHELL_CHOICE "$DOTFILES_LOCATION/shell/$SHELL_CHOICE/init"

# install the preferred macOS utilities and devtools
if [ "$(uname)" = 'Darwin' ]; then
    if ! command -v brew > /dev/null 2>&1; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv $SHELL_CHOICE)"
    fi

    brew install \
        ansible \
        asdf \
        bash-completion \
        fzf \
        git \
        go \
        htop \
        imagemagick \
        jq \
        kind \
        kubernetes-cli \
        maven \
        nmap \
        openssl \
        p7zip \
        rename \
        shellcheck \
        the_silver_searcher \
        tmux \
        tree \
        vim \
        watch

    brew install --cask \
        boom-3d \
        brave-browser \
        claude \
        claude-code \
        calibre \
        font-fira-code \
        imazing \
        iterm2 \
        vlc \
        visual-studio-code

    brew tap beeftornado/rmtree

    # python
    asdf plugin-add python
    asdf install python latest:3

    # node
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install nodejs latest
    asdf global nodejs latest

    # ruby
    asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
    asdf install ruby latest
fi
