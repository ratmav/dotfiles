#!/bin/bash

source ./bash/python.sh
source ./bash/node.sh


install_homebrew() {
  echo "...checking homebrew install..."
  if type brew > /dev/null 2>&1; then
    echo "......homebrew already installed"
  else
    URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
    /usr/bin/ruby -e "$(curl -fsSL $URL)"
    echo "......installed homebrew"
  fi
}

homebrew() {
  PACKAGES=("git" "neovim" "python" "pyenv" "pyenv-virtualenv" "rbenv")
  for package in "${PACKAGES[@]}"; do
    echo "...checking $package install..."
    if brew list | grep $package > /dev/null 2>&1; then
      echo "......$package already installed"
    else
      brew install $package
      echo "...installed $package via homebrew..."
    fi
  done
}

bootstrap_mac_os() {
  copy_fonts_mac
  install_homebrew
  homebrew
  pypi_packages
  nvm
}
