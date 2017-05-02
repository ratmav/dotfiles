#!/bin/bash

source ./bootstrap/python.sh
source ./bootstrap/node.sh


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

bootstrap_mac_os() {
  copy_fonts_mac
  install_homebrew
  bootstrap_node
  bootstrap_python
}
