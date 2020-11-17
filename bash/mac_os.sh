#!/usr/bin/env bash

homebrew() {
  echo "...checking homebrew install"
  if type brew > /dev/null 2>&1; then
    echo "......homebrew already installed"
  else
    URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
    /usr/bin/ruby -e "$(curl -fsSL $URL)"
    brew tap homebrew/cask-versions
    echo "......installed homebrew"
  fi
}

brew_packages() {
  PACKAGES=("bash-completion" "git" "neovim" "reattach-to-user-namespace"
    "clamav" "bash" "shellcheck" "tree" "grep" "pandoc" "librsvg" "python" "jq"
    "yq" "hyper")
  for package in "${PACKAGES[@]}"; do
    echo "...checking $package install"
    if brew list | grep $package > /dev/null 2>&1; then
      echo "......$package already installed"
    else
      brew install $package
      echo "......installed $package via homebrew"
    fi
  done
}

cask_packages() {
  PACKAGES=("brave-browser" "basictex")
  for package in "${PACKAGES[@]}"; do
    echo "...checking $package install"
    if brew cask list | grep $package > /dev/null 2>&1; then
      echo "......$package already installed"
    else
      brew cask install $package
      echo "......installed $package via homebrew cask"
    fi
  done
}

brew_bash() {
  LINE='/usr/local/bin/bash'
  FILE='/etc/shells'
  grep -qF -- "$LINE" "$FILE" || echo "$LINE" | sudo tee -a "$FILE" > /dev/null
  chsh -s /usr/local/bin/bash
}

bootstrap_mac_os() {
  homebrew
  brew_packages
  cask_packages
  brew_bash
}
