#!/usr/bin/bash

# nvim
mkdir -p ~/.config/nvim/
ln -fbs "$HOME/develop/dotfiles/init.vim" ~/.config/nvim/init.vim

# zsh
ln -fbs "$HOME/develop/dotfiles/zshrc" ~/.zshrc
