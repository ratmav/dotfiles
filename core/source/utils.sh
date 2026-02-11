#!/usr/bin/env bash

_utils_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${_utils_module_dir}/utils/exists.sh"
source "${_utils_module_dir}/utils/stream.sh"
source "${_utils_module_dir}/utils/tui.sh"

ish_utils_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish utils [command]

commands:
  exists       check if things exist
  tui          terminal user interface functions
EOF
}

ish_utils_route() {
  case "${1-}" in
  exists)
    shift
    case "${1-}" in
      --executable=*)
        local cmd="${1#*=}"
        if ish_utils_exists_executable "$@"; then
          ish_utils_tui_info --message="executable '$cmd' exists"
        else
          ish_utils_tui_error --message="executable '$cmd' not found"
        fi
        ;;
      --file=*)
        local path="${1#*=}"
        if ish_utils_exists_file "$@"; then
          ish_utils_tui_info --message="file '$path' exists"
        else
          ish_utils_tui_error --message="file '$path' not found"
        fi
        ;;
      help|"")
        ish_utils_stream_multiline_stderr <<EOF
usage: ish utils exists [option]

options:
  --executable=CMD   check if command is available in PATH
  --file=PATH        check if file exists
EOF
        ;;
      *)
        ish_utils_tui_error --message="unknown option: ${1-}"
        ;;
    esac
    ;;
  tui)
    shift
    ish_utils_tui_route "$@"
    ;;
  help|"")
    ish_utils_help
    ;;
  *)
    ish_utils_tui_error --message="unknown utils command: ${1-}"
    ;;
  esac
}
