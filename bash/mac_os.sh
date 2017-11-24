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
  PACKAGES=("git" "python" "tmux" "reattach-to-user-namespace" "neovim" "pyenv"
            "pyenv-virtualenv" "rbenv")
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

casks() {
  echo "...(re)installing homebrew cask"
  brew tap caskroom/cask 1>/dev/null
  PACKAGES=("iterm2" "spectacle")
  for package in "${PACKAGES[@]}"; do
    echo "......(re)installing $package cask"
    brew cask reinstall $package 1>/dev/null
  done
}

bootstrap_mac_os() {
  install_homebrew
  homebrew
  casks
  pypi_packages
  nvm
}
