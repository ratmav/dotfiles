#!/usr/bin/env bash

ish_utils_exists_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish utils exists [option]

options:
  --executable=CMD   check if command is available in PATH
  --file=PATH        check if file exists
EOF
}

ish_utils_exists_executable() {
  local command=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --executable=*)
        command="${1#*=}"
        shift
        ;;
      *)
        ish_utils_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$command" ]] && ish_utils_tui_error --message="--executable= required"

  type "$command" > /dev/null 2>&1
}

ish_utils_exists_file() {
  local path=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --file=*)
        path="${1#*=}"
        shift
        ;;
      *)
        ish_utils_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$path" ]] && ish_utils_tui_error --message="--file= required"

  [[ -f "$path" ]]
}
