#!/usr/bin/env bash

utils_tui_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_PACKAGES_DIR}/ish/source/utils/exists.sh"
source "${ISH_PACKAGES_DIR}/ish/source/utils/stream.sh"
source "${utils_tui_module_dir}/tui/template.sh"

utils_tui_set_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    ISH_TUI_ERROR=$'\033[0;31m'
    ISH_TUI_CLEAR=$'\033[0m'
    ISH_TUI_INFO=$'\033[0;32m'
    ISH_TUI_WARN=$'\033[0;33m'
  else
    ISH_TUI_ERROR=''
    ISH_TUI_CLEAR=''
    ISH_TUI_INFO=''
    ISH_TUI_WARN=''
  fi
}

utils_tui_error() {
  local message=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --message=*)
        message="${1#*=}"
        shift
        ;;
      *)
        # use utils_stream_stderr directly to avoid circular dependency
        utils_stream_stderr "${ISH_TUI_ERROR}unknown option: $1"
        exit 1
        ;;
    esac
  done

  if [[ -z "$message" ]]; then
    utils_stream_stderr "${ISH_TUI_ERROR}--message= required${ISH_TUI_CLEAR}"
    exit 1
  fi

  utils_stream_stderr "${ISH_TUI_ERROR}${message}${ISH_TUI_CLEAR}"
  exit 1
}

utils_tui_info() {
  local message=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --message=*)
        message="${1#*=}"
        shift
        ;;
      *)
        # use utils_stream_stderr directly to avoid circular dependency
        utils_stream_stderr "${ISH_TUI_ERROR}unknown option: $1"
        exit 1
        ;;
    esac
  done

  if [[ -z "$message" ]]; then
    utils_stream_stderr "${ISH_TUI_ERROR}--message= required${ISH_TUI_CLEAR}"
    return 1
  fi

  utils_stream_stderr "${ISH_TUI_INFO}${message}${ISH_TUI_CLEAR}"
}

utils_tui_warn() {
  local message=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --message=*)
        message="${1#*=}"
        shift
        ;;
      *)
        # use utils_stream_stderr directly to avoid circular dependency
        utils_stream_stderr "${ISH_TUI_ERROR}unknown option: $1"
        exit 1
        ;;
    esac
  done

  if [[ -z "$message" ]]; then
    utils_stream_stderr "${ISH_TUI_ERROR}--message= required${ISH_TUI_CLEAR}"
    return 1
  fi

  utils_stream_stderr "${ISH_TUI_WARN}${message}${ISH_TUI_CLEAR}"
}

utils_tui_quiet() {
  "${1-}" > /dev/null
}

utils_tui_confirm() {
  local prompt="${1:-continue?}"
  local response

  echo -n "${prompt} [Y/n] " >&2
  read -r response

  case "$response" in
    [Nn]|[Nn][Oo])
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

utils_tui_help() {
  utils_stream_multiline_stderr <<EOF
usage: ish tui [command]

commands:
  info --message=TEXT      output info message
  warn --message=TEXT      output warning message
  error --message=TEXT     output error message
  confirm                  prompt for confirmation
  set-colors               initialize color variables
  template file --path=PATH  output template file contents
EOF
}

# Routing function - explicitly dispatches commands to functions.
#
# Why explicit routing?
# - Sourcing this file loads function definitions without side effects
# - Positional parameters ($1, $2, etc.) are stateful and inherited on source
# - Automatic case statements would execute with inherited args, causing unwanted behavior
# - Explicit routing via utils_tui_route() gives callers full control over dispatch
#
# Benefits:
# - Other modules can source this file safely (just gets functions)
# - Other modules can call functions directly: utils_tui_info --message="message"
# - Other modules can dispatch via router if needed: utils_tui_route "$@"
# - CLI can dogfood by calling: source bash/utils/tui.sh && utils_tui_route "$@"
# - Testable: ish tui info "test" works because ish explicitly calls utils_tui_route
utils_tui_route() {
  case "${1-}" in
    info)
      shift
      utils_tui_info "$@"
      ;;
    warn)
      shift
      utils_tui_warn "$@"
      ;;
    error)
      shift
      utils_tui_error "$@"
      ;;
    confirm)
      shift
      utils_tui_confirm "$@"
      ;;
    set-colors)
      utils_tui_set_colors
      ;;
    template)
      shift
      case "${1-}" in
        file)
          shift
          utils_tui_template_file "$@"
          ;;
        "")
          utils_stream_multiline_stderr <<EOF
usage: ish tui template [command]

commands:
  file --path=PATH    output template file contents
EOF
          ;;
        *)
          utils_tui_error --message="unknown tui template command: ${1-}"
          ;;
      esac
      ;;
    help|"")
      utils_tui_help
      ;;
    *)
      utils_tui_error --message="unknown tui command: ${1-}"
      ;;
  esac
}
