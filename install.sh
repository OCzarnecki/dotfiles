#!/usr/bin/env bash

SRC_DIR=$(pwd)

# i3
mkdir -p ~/.config/i3/
ln -sf "$SRC_DIR/i3-config" ~/.config/i3/config
ln -sf "$SRC_DIR/secrets/i3-secrets" ~/.config/i3/i3-secrets

# nvim (lisp config)
mkdir -p ~/.config/nvim/lua/config
ln -sf "$SRC_DIR/init.lua" ~/.config/nvim/init.lua
ln -sf "$SRC_DIR/config.lua" ~/.config/nvim/lua/config.lua
ln -sf "$SRC_DIR/secrets/nvim-secrets.lua" ~/.config/nvim/lua/config/secrets.lua

# XCompose
ln -sf "$SRC_DIR/XCompose" ~/.XCompose

# zsh
ln -sf "$SRC_DIR/zshrc" ~/.zshrc

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
