#!/usr/bin/env bash

ish_lint_all() {
  if ! ish_utils_exists_executable --executable=shellcheck; then
    ish_utils_tui_error --message="${FUNCNAME[0]}: shellcheck not installed."
  fi

  shellcheck "${ISH_PACKAGES_DIR}"/**/*.sh "${ISH_PACKAGES_DIR}/../ish"
}

ish_lint_bash() {
  if ! ish_utils_exists_executable --executable=shellcheck; then
    ish_utils_tui_error --message="${FUNCNAME[0]}: shellcheck not installed."
  fi

  shellcheck "${ISH_PACKAGES_DIR}"/**/*.sh
}

ish_lint_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish lint [target]

targets:
  all          lint all files
  bash         lint bash scripts only
EOF
}

ish_lint_route() {
  case "${1-}" in
  all)
    shift
    ish_lint_all
    ;;
  bash)
    shift
    ish_lint_bash
    ;;
  help|"")
    ish_lint_help
    ;;
  *)
    ish_utils_tui_error --message="unknown lint target: ${1-}"
    return 1
    ;;
  esac
}
