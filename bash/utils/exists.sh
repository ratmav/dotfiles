#!/usr/bin/env bash

utils_exists_executable() {
  local command=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --executable=*)
        command="${1#*=}"
        shift
        ;;
      *)
        utils_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$command" ]] && utils_tui_error --message="--executable= required"

  type "$command" > /dev/null 2>&1
}

utils_exists_file() {
  local path=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --file=*)
        path="${1#*=}"
        shift
        ;;
      *)
        utils_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$path" ]] && utils_tui_error --message="--file= required"

  [[ -f "$path" ]]
}
