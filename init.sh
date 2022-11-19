#!/bin/sh

# Default dotfiles location
DOTFILES_LOCATION="$HOME/.dotfiles"
if [ -z "$1" ]; then
    echo "provide specify your preferred shell: 'zsh' or 'bash'"
    exit 1
fi
if [ -z "$2" ]; then
    echo "using '${DOTFILES_LOCATION}' as your dotfiles location"
else
    DOTFILES_LOCATION="$2"
fi

# Remove any previous config
[ -f "$HOME/.gitconfig" ]   && rm "$HOME/.gitconfig"
[ -f "$HOME/.profile" ]     && rm "$HOME/.profile"
[ -f "$HOME/.bashrc" ]      && rm "$HOME/.bashrc"
[ -f "$HOME/.zshrc" ]       && rm "$HOME/.zshrc"
[ -f "$HOME/.vimrc" ]       && rm "$HOME/.vimrc"
[ -f "$HOME/.tmux.conf" ]   && rm "$HOME/.tmux.conf"
[ -f "$HOME/.vim" ]         && rm -r "$HOME/.vim"

case $1 in
"bash")
    bash "$DOTFILES_LOCATION/shell/bash/init";;
"zsh")
    zsh "$DOTFILES_LOCATION/shell/zsh/init";;
*)
esac

# link vim & tmux config
ln -s "${DOTFILES_LOCATION}/.vim" "$HOME/.vim"
ln -s "${DOTFILES_LOCATION}/.vimrc" "$HOME/.vimrc"
ln -s "${DOTFILES_LOCATION}/.tmux.conf" "$HOME/.tmux.conf"
ln -s "${DOTFILES_LOCATION}/.gitconfig" "$HOME/.gitconfig"

# install the preferred macOS utilities and devtools
if [ "$(uname)" = 'Darwin' ]; then
    brew install ansible vim git \
        shellcheck kubernetes-cli kind maven go jq openssl \
        watch bash-completion p7zip htop rename fzf tree \
        the_silver_searcher tmux nmap asdf imagemagick \
        iterm font-fira-code filebot calibre boom-3d \
        brave-browser rectangle visual-studio-code \
        imazing vlc

    brew tap beeftornado/rmtree

    # python
    asdf plugin-add python
    asdf install python latest:3

    # node
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install nodejs latest
    asdf global nodejs latest

    # node
    asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
    asdf install ruby latest:2.7

    # sdkman for java deps
    curl -s "https://get.sdkman.io" | bash
fi
