#!/usr/bin/env bash

macos_brew_bash() {
  LINE='/usr/local/bin/bash'
  FILE='/etc/shells'
  grep -qF -- "$LINE" "$FILE" || echo "$LINE" | sudo tee -a "$FILE" > /dev/null
  chsh -s /usr/local/bin/bash
  msg "${OK}macos: configured macos to use homebrew's bash."
}

macos_brew_packages() {
  # librsvg python are used with pandoc.
  PACKAGES=("coreutils" "bash-completion" "neovim" "reattach-to-user-namespace"
    "clamav" "bash" "shellcheck" "tree" "grep" "pandoc" "librsvg" "python" "jq"
    "yq" "hyper" "gpg" "git")
  for package in "${PACKAGES[@]}"; do
    if brew list | grep $package > /dev/null 2>&1; then
      msg "${WARN}macos: $package already installed."
    else
      brew install $package
      msg "${OK}macos: installed $package via homebrew."
    fi
  done
}

macos_cask_packages() {
  # basictex is used with pandoc.
  PACKAGES=("brave-browser" "basictex" "virtualbox" "vagrant" "docker" "signal")
  for package in "${PACKAGES[@]}"; do
    if brew list --cask | grep $package > /dev/null 2>&1; then
      msg "${WARN}macos: $package already installed."
    else
      brew install --cask $package
      msg "${OK}macos: installed $package via homebrew cask."
    fi
  done
}

macos_homebrew() {
  if type brew > /dev/null 2>&1; then
    msg "${WARN}macos: homebrew already installed."
  else
    URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
    /usr/bin/ruby -e "$(curl -fsSL $URL)"
    brew tap homebrew/cask-versions
    msg "${OK}macos: installed homebrew."
  fi
}

main_macos() {
  macos_homebrew
  macos_brew_packages
  macos_cask_packages
  macos_brew_bash
}
