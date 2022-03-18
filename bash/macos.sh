#!/usr/bin/env bash

macos_brew_bash() {
  if [[ $(uname) == "Darwin" ]]; then
    LINE='/usr/local/bin/bash'
    FILE='/etc/shells'
    grep -qF -- "$LINE" "$FILE" || echo "$LINE" | sudo tee -a "$FILE" > /dev/null
    chsh -s /usr/local/bin/bash
    msg "${OK}${FUNCNAME[0]}: configured macos to use homebrew's bash."
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

macos_brew_packages() {
  if [[ $(uname) == "Darwin" ]]; then
    # librsvg and python are used with pandoc.
    PACKAGES=("shellcheck" "coreutils" "bash-completion" "neovim"
      "reattach-to-user-namespace" "bash" "grep" "pandoc" "librsvg" "python"
      "gpg" "git")
    for package in "${PACKAGES[@]}"; do
      if brew list | grep $package > /dev/null 2>&1; then
        msg "${WARN}${FUNCNAME[0]}: $package already installed."
      else
        quiet "brew install $package"
        msg "${OK}${FUNCNAME[0]}: installed $package via homebrew."
      fi
    done
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

macos_cask_packages() {
  if [[ $(uname) == "Darwin" ]]; then
    # basictex is used with pandoc.
    PACKAGES=("basictex" "wezterm")
    for package in "${PACKAGES[@]}"; do
      if brew list --cask | grep $package > /dev/null 2>&1; then
        msg "${WARN}${FUNCNAME[0]}: $package already installed."
      else
        quiet "brew install --cask $package"
        msg "${OK}${FUNCNAME[0]}: installed $package via homebrew cask."
      fi
    done
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

macos_homebrew() {
  if [[ $(uname) == "Darwin" ]]; then
    if type brew > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: homebrew already installed."
    else
      URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
      /usr/bin/ruby -e "$(curl -fsSL $URL)"
      brew tap homebrew/cask-versions
      msg "${OK}${FUNCNAME[0]}: installed homebrew."
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

main_macos() {
  if [[ $(uname) == "Darwin" ]]; then
    macos_homebrew
    macos_brew_packages
    macos_cask_packages
    macos_brew_bash
    # macos_brew_wezterm
  fi
}
