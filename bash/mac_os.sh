#!/bin/bash

source ./bash/python.sh

copy_fonts_mac() {
  echo "...copying fonts on mac..."
  cp fonts/* ~/Library/Fonts/
  echo "......copied fonts"
}

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
  PACKAGES=("ctags" "git" "tmux" "vim" "python")
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
}
