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

unshallow_clones() {
  # install git so we can use it.
  brew install git

  # pull unshallow clones.
  git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core fetch --unshallow
  git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask fetch --unshallow
}

brew_packages() {
  # librsvg python are used with pandoc.
  PACKAGES=("bash-completion" "neovim" "reattach-to-user-namespace"
    "clamav" "bash" "shellcheck" "tree" "grep" "pandoc" "librsvg" "python" "jq"
    "yq" "hyper" "gpg")
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
  # basictex is used with pandoc.
  PACKAGES=("brave-browser" "basictex")
  for package in "${PACKAGES[@]}"; do
    echo "...checking $package install"
    if brew cask list | grep $package > /dev/null 2>&1; then
      echo "......$package already installed"
    else
      brew install --cask $package
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
  unshallow_clones
  brew_packages
  cask_packages
  brew_bash
}
