#!/usr/bin/bash

SRC_DIR=`pwd`

# nvim
mkdir -p ~/.config/nvim/
ln -fbs "$SRC_DIR/init.vim" ~/.config/nvim/init.vim

# XCompose
ln -fbs "$SRC_DIR/XCompose" ~/.XCompose

# zsh
ln -fbs "$SRC_DIR/zshrc" ~/.zshrc

echo "User configuration installed!"

### Global system configuration.

if [ "$EUID" -eq 0 ] ; then
  # faillock.conf
  chown root:root "$SRC_DIR/faillock.conf"
  ln -fbs "$SRC_DIR/faillock.conf" "/etc/security/faillock.conf"

  # logind.conf
  chown root:root "$SRC_DIR/logind.conf"
  ln -fbs "$SRC_DIR/logind.conf" "/etc/systemd/logind.conf"
else
  echo "Not running as root, skipping global system configuration."
  exit 1
fi
