#!/bin/bash

source ./bash/python.sh

copy_fonts_mac() {
  echo "...copying fonts on mac..."
  cp fonts/* ~/Library/Fonts/
  echo "......copied fonts"
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
  install_python
  pypi_packages
}
