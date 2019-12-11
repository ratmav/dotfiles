#!/bin/bash

install_homebrew() {
  echo "...checking homebrew install"
  if type brew > /dev/null 2>&1; then
    echo "......homebrew already installed"
  else
    URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
    /usr/bin/ruby -e "$(curl -fsSL $URL)"
    echo "......installed homebrew"
  fi
}

homebrew() {
  PACKAGES=("bash-completion" "git" "neovim" "reattach-to-user-namespace" "tmux"
    "clamav" "rust" "bash")
  for package in "${PACKAGES[@]}"; do
    echo "...checking $package install"
    if brew list | grep $package > /dev/null 2>&1; then
      echo "......$package already installed"
    else
      brew install $package
      echo "...installed $package via homebrew"
    fi
  done
}

alacritty_config() {
  mkdir -p $HOME/.config/alacritty
  rm -f $HOME/.config/alacritty/alacritty.yml
  ln -s $PWD/alacritty.yml $HOME/.config/alacritty/alacritty.yml
}

alacritty_install() {
  if brew cask list | grep alacritty > /dev/null 2>&1; then
    echo "...alacritty already installed"
  else
    brew cask install alacritty
    echo "...installed alacritty via homebrew"
  fi
}

brew_bash() {
  LINE='/usr/local/bin/bash'
  FILE='/etc/shells'
  grep -qF -- "$LINE" "$FILE" || echo "$LINE" | sudo tee -a "$FILE" > /dev/null
  chsh -s /usr/local/bin/bash
}

bootstrap_mac_os() {
  install_homebrew
  homebrew
  alacritty_install
  alacritty_config
  brew_bash
}
