# .dotfiles terminal settings

Clone the repository to `.dotfiles` in your `$HOME` directory and execute the init script
to setup the necessary dotfiles for tmux, vim, Mac profiles and install extra 3rd party utils.

```
git clone --recursive https://github.com/lackerman/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
sh init.sh bash "${DOTFILES_LOCATION}"
```

To update the git submodules for iterm2-colors and tmux-themepack, run the following
```bash
git submodule update --init --recursive
git submodule foreach --recursive git fetch
git submodule foreach git merge origin master
```

## vim

The first time your start vim, vim may report some errors. Continue and once it has started,
enter `Ctrl-C` followed by `:PlugInstall` to install the plugins needed by vim.

## Configure Golang support in Vim

Once you've opened vim, type `:GoInstallBinaries` to install all necessary
Go binaries required for Go development in Vim.
