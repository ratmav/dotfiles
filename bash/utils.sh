#!/usr/bin/env bash

_utils_script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd -P)
_utils_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${_utils_module_dir}/utils/exists.sh"
source "${_utils_module_dir}/utils/stream.sh"
source "${_utils_module_dir}/utils/tui.sh"

utils_help() {
  utils_stream_multiline_stderr <<EOF
usage: ish utils [command]

commands:
  exists       check if things exist
  tui          terminal user interface functions
EOF
}

utils_route() {
  case "${1-}" in
  exists)
    shift
    case "${1-}" in
      --executable=*)
        local cmd="${1#*=}"
        if utils_exists_executable "$@"; then
          utils_tui_info --message="executable '$cmd' exists"
        else
          utils_tui_error --message="executable '$cmd' not found"
        fi
        ;;
      --file=*)
        local path="${1#*=}"
        if utils_exists_file "$@"; then
          utils_tui_info --message="file '$path' exists"
        else
          utils_tui_error --message="file '$path' not found"
        fi
        ;;
      help|"")
        utils_stream_multiline_stderr <<EOF
usage: ish utils exists [option]

options:
  --executable=CMD   check if command is available in PATH
  --file=PATH        check if file exists
EOF
        ;;
      *)
        utils_tui_error --message="unknown option: ${1-}"
        ;;
    esac
    ;;
  tui)
    shift
    utils_tui_route "$@"
    ;;
  help|"")
    utils_help
    ;;
  *)
    utils_tui_error --message="unknown utils command: ${1-}"
    ;;
  esac
}
