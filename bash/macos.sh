#!/usr/bin/env bash

macos_brew_bash() {
  LINE='/usr/local/bin/bash'
  FILE='/etc/shells'
  grep -qF -- "$LINE" "$FILE" || echo "$LINE" | sudo tee -a "$FILE" > /dev/null
  chsh -s /usr/local/bin/bash
}

macos_brew_packages() {
  # librsvg python are used with pandoc.
  PACKAGES=("coreutils" "bash-completion" "neovim" "reattach-to-user-namespace"
    "clamav" "bash" "shellcheck" "tree" "grep" "pandoc" "librsvg" "python" "jq"
    "yq" "hyper" "gpg" "go-task/tap/go-task")
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

macos_cask_packages() {
  # basictex is used with pandoc.
  PACKAGES=("brave-browser" "basictex" "virtualbox" "vagrant" "docker" "signal")
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

macos_homebrew() {
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

macos_unshallow_clones() {
  # install git so we can use it.
  brew install git

  # pull unshallow clones.
  git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core fetch --unshallow
  git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask fetch --unshallow
}

main_macos() {
  msg "${WARN}macos: uncomment functions in main_macos"
  #macos_homebrew
  #macos_unshallow_clones
  #macos_brew_packages
  #macos_cask_packages
  #macos_brew_bash
}
