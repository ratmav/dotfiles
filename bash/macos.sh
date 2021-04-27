#!/usr/bin/env bash

macos_brew_bash() {
  if [[ $(uname) == "Darwin" ]]; then
    LINE='/usr/local/bin/bash'
    FILE='/etc/shells'
    grep -qF -- "$LINE" "$FILE" || echo "$LINE" | sudo tee -a "$FILE" > /dev/null
    chsh -s /usr/local/bin/bash
    msg "${OK}macos_brew_bash: configured macos to use homebrew's bash."
  else
    die "macos_brew_bash: unsupported operating system."
  fi
}

macos_brew_packages() {
  if [[ $(uname) == "Darwin" ]]; then
    # librsvg and python are used with pandoc.
    PACKAGES=("coreutils" "bash-completion" "neovim" "reattach-to-user-namespace"
      "clamav" "bash" "shellcheck" "tree" "grep" "pandoc" "librsvg" "python" "jq"
      "yq" "gpg" "git" "gawk" "htop")
    for package in "${PACKAGES[@]}"; do
      if brew list | grep $package > /dev/null 2>&1; then
        msg "${WARN}macos_brew_packages: $package already installed."
      else
        quiet "brew install $package"
        msg "${OK}macos_brew_packages: installed $package via homebrew."
      fi
    done
  else
    die "macos_brew_packages: unsupported operating system."
  fi
}

macos_cask_packages() {
  if [[ $(uname) == "Darwin" ]]; then
    # basictex is used with pandoc.
    PACKAGES=("basictex" "virtualbox" "vagrant" "docker" "balenaetcher")
    for package in "${PACKAGES[@]}"; do
      if brew list --cask | grep $package > /dev/null 2>&1; then
        msg "${WARN}macos_cask_packages: $package already installed."
      else
        quiet "brew install --cask $package"
        msg "${OK}macos_cask_packages: installed $package via homebrew cask."
      fi
    done
  else
    die "macos_cask_packages: unsupported operating system."
  fi
}

macos_homebrew() {
  if [[ $(uname) == "Darwin" ]]; then
    if type brew > /dev/null 2>&1; then
      msg "${WARN}macos_homebrew: homebrew already installed."
    else
      URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
      /usr/bin/ruby -e "$(curl -fsSL $URL)"
      brew tap homebrew/cask-versions
      msg "${OK}macos_homebrew: installed homebrew."
    fi
  else
    die "macos_homebrew: unsupported operating system."
  fi
}

main_macos() {
  if [[ $(uname) == "Darwin" ]]; then
    macos_homebrew
    macos_brew_packages
    macos_cask_packages
    macos_brew_bash

    msg "${WARN}main_macos: uhk agent needs manual installation from https://github.com/UltimateHackingKeyboard/agent/releases/latest"
    msg "${WARN}main_macos: cutter needs manual installation from https://cutter.re/download/"
    msg "${WARN}main_macos: neovide needs to be downloaded from https://github.com/Kethku/neovide/actions"
  else
    die "main_macos: unsupported operating system."
  fi
}
