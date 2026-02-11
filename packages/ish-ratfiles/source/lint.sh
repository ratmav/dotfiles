#!/usr/bin/env bash

ish_ratfiles_lint_all() {
  if ! ish_utils_exists_executable --executable=shellcheck; then
    ish_utils_tui_error --message="${FUNCNAME[0]}: shellcheck not installed."
  fi

  shellcheck "${ISH_PACKAGES}/ish-ratfiles/source"/**/*.sh
}

ish_ratfiles_lint_bash() {
  if ! ish_utils_exists_executable --executable=shellcheck; then
    ish_utils_tui_error --message="${FUNCNAME[0]}: shellcheck not installed."
  fi

  shellcheck "${ISH_PACKAGES}/ish-ratfiles/source"/**/*.sh
}

ish_ratfiles_lint_route() {
  case "${1-}" in
  all)
    shift
    ish_ratfiles_lint_all
    ;;
  bash)
    shift
    ish_ratfiles_lint_bash
    ;;
  "")
    ish_utils_stream_multiline_stderr <<EOF
usage: ish ratfiles lint [target]

targets:
  all          lint all files
  bash         lint bash scripts only
EOF
    ;;
  *)
    ish_utils_tui_error --message="unknown lint target: ${1-}"
    return 1
    ;;
  esac
}
