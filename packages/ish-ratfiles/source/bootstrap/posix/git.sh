#!/usr/bin/env bash

ish_ratfiles_bootstrap_posix_git_configure() {
  if ! ish_utils_exists_executable --executable=git; then
    ish_utils_tui_error --message="${FUNCNAME[0]}: git not found. Install git first."
    return 1
  fi

  if ! ish_utils_exists_executable --executable=nvim; then
    ish_utils_tui_warn --message="${FUNCNAME[0]}: nvim not found. Skipping git editor configuration."
  else
    git config --global core.editor "$(which nvim)"
    ish_utils_tui_info --message="${FUNCNAME[0]}: configured git editor."
  fi

  git config --global core.excludesfile "$HOME/.gitignore_global"
  ish_utils_tui_info --message="${FUNCNAME[0]}: configured global gitignore."

  git config --global push.autoSetupRemote true
  ish_utils_tui_info --message="${FUNCNAME[0]}: configured git to automatically setup remote branches on push."
}
