#!/usr/bin/env bash

# Foundation layer. Depends only on color.
# Command availability detection — wraps the shell `type` builtin.

ish_exists_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ish_exists_module_dir}/color.sh"
ish_color_init

ish_exists_executable() {
  local command=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --executable=*)
        command="${1#*=}"
        shift
        ;;
      *)
        _exists_error "unknown option: $1"
        ;;
    esac
  done

  [[ -z "$command" ]] && _exists_error "--executable= required"

  type "$command" > /dev/null 2>&1
}

# Private functions

_exists_error() {
  printf '%s\n' "${ISH_COLOR_RED}ish_exists: ${1}${ISH_COLOR_CLEAR}" >&2
  exit 1
}
