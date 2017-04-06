#!/bin/bash


install_nvm() {
  echo "...checking nvm install..."
  if [ -f "$HOME/.nvm/nvm.sh" ]; then
    echo "......nvm already installed"
  else
    URL="https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh"
    curl -o- $URL | bash
    echo "......installed nvm"
  fi
}

install_node() {
  echo "...checking node install..."
  if type node > /dev/null 2>&1; then
    echo "......node already installed"
  else
    source $HOME/.bash_profile && nvm install stable
    echo "......installed node"
  fi
}

install_livedown() {
  echo "...checking livedown install..."
  if type livedown > /dev/null 2>&1; then
    echo "......livedown already installed"
  else
    source $HOME/.bash_profile && npm install -g livedown
    echo "...installed livedown..."
  fi
}

bootstrap_node() {
  install_nvm
  install_node
  install_livedown
}
