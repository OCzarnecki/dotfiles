#!/usr/bin/bash

SRC_DIR=$(pwd)

# i3
mkdir -p ~/.config/i3/
ln -fbs "$SRC_DIR/i3-config" ~/.config/i3/config
ln -fbs "$SRC_DIR/secrets/i3-secrets" ~/.config/i3/i3-secrets

# nvim (lisp config)
mkdir -p ~/.config/nvim/
rm ~/.config/nvim/init.vim 2>/dev/null || true
[ -f "$HOME/.config/nvim/init.vim" ] && rm ~/.config/nvim/init.vim
ln -fbs "$SRC_DIR/init.lua" ~/.config/nvim/init.lua

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
