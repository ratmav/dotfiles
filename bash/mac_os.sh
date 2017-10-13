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

homebrew_packages() {
  PACKAGES=("git" "python" "pyenv" "pyenv-virtualenv" "rbenv")
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

brew_cask(){
  PACKAGES=("atom" "spectacle")
  for package in "${PACKAGES[@]}"; do
    brew cask install $package
    echo "...(re)installed $package via homebrew..."
  done
}

bootstrap_mac_os() {
  install_homebrew
  homebrew_packages
  brew_cask
  pypi_packages
  nvm
}
