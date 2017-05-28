#!/bin/bash

source ./bash/python.sh

copy_fonts_mac() {
  echo "...copying fonts on mac..."
  cp fonts/* ~/Library/Fonts/
  echo "......copied fonts"
}

install_ctags() {
  echo "...checking ctags install..."
  if brew list | grep ctags > /dev/null 2>&1; then
    echo "......ctags already installed"
  else
    brew install ctags
    echo "...installed ctags via homebrew..."
  fi
}

install_git() {
  echo "...checking git install..."
  if type git > /dev/null 2>&1; then
    echo "......git already installed"
  else
    brew install git
    echo "......installed git"
  fi
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

install_neovim() {
  echo "...checking neovim install..."
  if brew list | grep neovim > /dev/null 2>&1; then
    echo "......neovim already installed"
  else
    brew install neovim/neovim/neovim
    echo "...installed neovim via homebrew..."
  fi
}

install_python() {
  echo "...checking python install..."
  if brew list | grep python > /dev/null 2>&1; then
    echo "......python already installed"
  else
    brew install python
    echo "...installed python via homebrew..."
  fi
}

bootstrap_mac_os() {
  copy_fonts_mac
  install_homebrew
  install_git
  install_ctags
  install_python
  install_neovim
  pypi_packages
}
