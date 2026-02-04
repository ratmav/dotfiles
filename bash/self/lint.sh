#!/usr/bin/env bash

self_lint_all() {
  if ! utils_exists_executable --executable=shellcheck; then
    utils_tui_error --message="${FUNCNAME[0]}: shellcheck not installed."
  fi

  shellcheck bash/**/*.sh ish
}

self_lint_bash() {
  if ! utils_exists_executable --executable=shellcheck; then
    utils_tui_error --message="${FUNCNAME[0]}: shellcheck not installed."
  fi

  shellcheck bash/**/*.sh
}
