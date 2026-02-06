#!/usr/bin/env bash

bootstrap_macos_homebrew_install() {
  if [[ $(platform_os) != "macos" ]]; then
    utils_tui_error --message="${FUNCNAME[0]}: unsupported operating system."
    return 1
  fi

  if utils_exists_executable --executable=brew; then
    utils_tui_warn --message="${FUNCNAME[0]}: homebrew already installed."
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    utils_tui_info --message="${FUNCNAME[0]}: installed homebrew."
  fi
}

bootstrap_macos_homebrew_brew() {
  if [[ $(platform_os) != "macos" ]]; then
    utils_tui_error --message="${FUNCNAME[0]}: unsupported operating system."
    return 1
  fi

  if ! utils_exists_executable --executable=brew; then
    utils_tui_error --message="${FUNCNAME[0]}: brew not found. Run 'ish bootstrap macos homebrew install' first."
    return 1
  fi

  # librsvg and python are used with pandoc.
  PACKAGES=("shellcheck" "coreutils" "bash-completion" "neovim"
    "reattach-to-user-namespace" "bash" "grep" "pandoc" "librsvg" "python"
    "gpg" "git" "cosign" "lulu" "direnv")

  for package in "${PACKAGES[@]}"; do
    if eval "$(/opt/homebrew/bin/brew shellenv)" && brew list | grep $package > /dev/null 2>&1; then
      utils_tui_warn --message="${FUNCNAME[0]}: $package already installed."
    else
      eval "$(/opt/homebrew/bin/brew shellenv)"
      utils_tui_quiet "brew install $package"
      utils_tui_info --message="${FUNCNAME[0]}: installed $package via homebrew."
    fi
  done
}

bootstrap_macos_homebrew_cask() {
  if [[ $(platform_os) != "macos" ]]; then
    utils_tui_error --message="${FUNCNAME[0]}: unsupported operating system."
    return 1
  fi

  if ! utils_exists_executable --executable=brew; then
    utils_tui_error --message="${FUNCNAME[0]}: brew not found. Run 'ish bootstrap macos homebrew install' first."
    return 1
  fi

  # basictex is used with pandoc.
  PACKAGES=("basictex" "wezterm" "wireshark" "firefox@developer-edition")

  for package in "${PACKAGES[@]}"; do
    if brew list --cask | grep $package > /dev/null 2>&1; then
      utils_tui_warn --message="${FUNCNAME[0]}: $package already installed."
    else
      eval "$(/opt/homebrew/bin/brew shellenv)"
      utils_tui_quiet "brew install --cask $package"
      utils_tui_info --message="${FUNCNAME[0]}: installed $package via homebrew cask."
    fi
  done
}
