#!/usr/bin/env bash

# Primitive layer. Built on file_descriptor.
# Process composition: connect, compose, tee with PIPESTATUS capture.

ish_pipe_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ish_pipe_module_dir}/file_descriptor.sh"

ISH_PIPE_STATUS=()

ish_pipe_connect() {
  local cmd_a="${1-}"
  local cmd_b="${2-}"

  [[ -z "$cmd_a" ]] && _pipe_error "first command required"
  [[ -z "$cmd_b" ]] && _pipe_error "second command required"

  "$cmd_a" | "$cmd_b"
  ISH_PIPE_STATUS=("${PIPESTATUS[@]}")
}

ish_pipe_compose() {
  [[ $# -lt 2 ]] && _pipe_error "at least two commands required"

  case $# in
    2) "$1" | "$2" ;;
    3) "$1" | "$2" | "$3" ;;
    4) "$1" | "$2" | "$3" | "$4" ;;
    5) "$1" | "$2" | "$3" | "$4" | "$5" ;;
    *) _pipe_error "compose supports up to 5 stages" ;;
  esac
  ISH_PIPE_STATUS=("${PIPESTATUS[@]}")
}

ish_pipe_tee() {
  [[ $# -eq 0 ]] && _pipe_error "at least one destination required"

  tee "$@"
}

ish_pipe_status() {
  local code

  for code in "${ISH_PIPE_STATUS[@]}"; do
    printf '%s\n' "$code"
  done
}

ish_pipe_require_success() {
  local i
  local code

  for i in "${!ISH_PIPE_STATUS[@]}"; do
    code="${ISH_PIPE_STATUS[$i]}"
    if [[ "$code" -ne 0 ]]; then
      _pipe_error "stage $((i + 1)) failed with exit code $code"
    fi
  done
}

# Private functions

_pipe_error() {
  printf '%s\n' "${ISH_COLOR_RED}ish_pipe: ${1}${ISH_COLOR_CLEAR}" >&2
  exit 1
}
