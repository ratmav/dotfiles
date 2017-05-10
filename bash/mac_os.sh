#!/bin/bash

source ./bash/python.sh
source ./bash/node.sh

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

install_ispell() {
  echo "...checking ispell install..."
  if type ispell > /dev/null 2>&1; then
    echo "......ispell already installed"
  else
    brew install ispell
    echo "......installed ispell"
  fi
}

install_poppler() {
    echo "...checking poppler install..."
    if brew list | grep poppler > /dev/null 2>&1; then
        echo "......poppler already installed"
    else
        brew install poppler
        echo "......installed poppler"
    fi
}

install_shellcheck() {
    echo "...checking shellcheck install..."
    if type shellcheck > /dev/null 2>&1; then
        echo "......shellcheck already installed"
    else
        brew install shellcheck
        echo "......installed shellcheck"
    fi
}

install_spacemacs() {
  echo "...checking spacemacs install..."
  if brew list | grep emacs > /dev/null 2>&1; then
    echo "......spacemacs already installed"
  else
    brew tap d12frosted/emacs-plus
    brew install emacs-plus --HEAD --with-natural-title-bars
    brew linkapps emacs-plus
    rm -rf $HOME/.emacs.d
    git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d
    echo "......installed spacemacs"
  fi
}


bootstrap_mac_os() {
  copy_fonts_mac
  install_homebrew
  install_git
  install_ispell
  install_shellcheck
  install_poppler
  install_spacemacs
  bootstrap_node
  bootstrap_python
}
