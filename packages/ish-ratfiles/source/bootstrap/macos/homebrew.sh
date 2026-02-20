#!/usr/bin/env bash

ish_ratfiles_bootstrap_macos_homebrew_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish ratfiles bootstrap macos homebrew [command]

commands:
  all       run all homebrew setup steps
  install   install homebrew
  brew      install brew packages
  cask      install cask packages
EOF
}

ish_ratfiles_bootstrap_macos_homebrew_install() {
  if [[ $(ish_platform_os) != "macos" ]]; then
    ish_tui_error --message="${FUNCNAME[0]}: unsupported operating system."
    return 1
  fi

  if ish_exists_executable --executable=brew; then
    ish_tui_warn --message="${FUNCNAME[0]}: homebrew already installed."
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ish_tui_info --message="${FUNCNAME[0]}: installed homebrew."
  fi
}

ish_ratfiles_bootstrap_macos_homebrew_brew() {
  if [[ $(ish_platform_os) != "macos" ]]; then
    ish_tui_error --message="${FUNCNAME[0]}: unsupported operating system."
    return 1
  fi

  if ! ish_exists_executable --executable=brew; then
    ish_tui_error --message="${FUNCNAME[0]}: brew not found. Run 'ish bootstrap macos homebrew install' first."
    return 1
  fi

  # librsvg and python are used with pandoc.
  PACKAGES=("shellcheck" "coreutils" "bash-completion" "neovim"
    "reattach-to-user-namespace" "bash" "grep" "pandoc" "librsvg" "python"
    "gpg" "git" "cosign" "lulu" "direnv")

  for package in "${PACKAGES[@]}"; do
    if eval "$(/opt/homebrew/bin/brew shellenv)" && brew list | grep $package > /dev/null 2>&1; then
      ish_tui_warn --message="${FUNCNAME[0]}: $package already installed."
    else
      eval "$(/opt/homebrew/bin/brew shellenv)"
      ish_tui_quiet "brew install $package"
      ish_tui_info --message="${FUNCNAME[0]}: installed $package via homebrew."
    fi
  done
}

ish_ratfiles_bootstrap_macos_homebrew_cask() {
  if [[ $(ish_platform_os) != "macos" ]]; then
    ish_tui_error --message="${FUNCNAME[0]}: unsupported operating system."
    return 1
  fi

  if ! ish_exists_executable --executable=brew; then
    ish_tui_error --message="${FUNCNAME[0]}: brew not found. Run 'ish bootstrap macos homebrew install' first."
    return 1
  fi

  # basictex is used with pandoc.
  PACKAGES=("basictex" "wezterm" "wireshark" "firefox@developer-edition")

  for package in "${PACKAGES[@]}"; do
    if brew list --cask | grep $package > /dev/null 2>&1; then
      ish_tui_warn --message="${FUNCNAME[0]}: $package already installed."
    else
      eval "$(/opt/homebrew/bin/brew shellenv)"
      ish_tui_quiet "brew install --cask $package"
      ish_tui_info --message="${FUNCNAME[0]}: installed $package via homebrew cask."
    fi
  done
}
