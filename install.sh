#!/usr/bin/bash

if [ "$EUID" -ne 0 ] ; then
  echo "Please run as root. Need to install global system configuration"
  exit 1
fi

SRC_DIR=`pwd`

# nvim
mkdir -p ~/.config/nvim/
ln -fbs "$SRC_DIR/init.vim" ~/.config/nvim/init.vim

# zsh
ln -fbs "$SRC_DIR/zshrc" ~/.zshrc

# logind.conf
ln -fbs "$SRC_DIR/logind.conf" "/etc/systemd/logind.conf"
