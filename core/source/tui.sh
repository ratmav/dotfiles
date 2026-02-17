#!/usr/bin/env bash

_tui_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${_tui_module_dir}/stream.sh"
source "${ISH_CORE}/source/utils/exists.sh"
source "${_tui_module_dir}/tui/template.sh"

ish_tui_set_colors() {
  ISH_TUI_ERROR="$ISH_COLOR_RED"
  ISH_TUI_INFO="$ISH_COLOR_GREEN"
  ISH_TUI_WARN="$ISH_COLOR_YELLOW"
  ISH_TUI_CLEAR="$ISH_COLOR_CLEAR"
}

ish_tui_error() {
  local message=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --message=*)
        message="${1#*=}"
        shift
        ;;
      *)
        ish_stream_stderr "${ISH_TUI_ERROR}unknown option: $1"
        exit 1
        ;;
    esac
  done

  if [[ -z "$message" ]]; then
    ish_stream_stderr "${ISH_TUI_ERROR}--message= required${ISH_TUI_CLEAR}"
    exit 1
  fi

  ish_stream_stderr "${ISH_TUI_ERROR}${message}${ISH_TUI_CLEAR}"
  exit 1
}

ish_tui_info() {
  local message=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --message=*)
        message="${1#*=}"
        shift
        ;;
      *)
        ish_stream_stderr "${ISH_TUI_ERROR}unknown option: $1"
        exit 1
        ;;
    esac
  done

  if [[ -z "$message" ]]; then
    ish_stream_stderr "${ISH_TUI_ERROR}--message= required${ISH_TUI_CLEAR}"
    return 1
  fi

  ish_stream_stderr "${ISH_TUI_INFO}${message}${ISH_TUI_CLEAR}"
}

ish_tui_warn() {
  local message=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --message=*)
        message="${1#*=}"
        shift
        ;;
      *)
        ish_stream_stderr "${ISH_TUI_ERROR}unknown option: $1"
        exit 1
        ;;
    esac
  done

  if [[ -z "$message" ]]; then
    ish_stream_stderr "${ISH_TUI_ERROR}--message= required${ISH_TUI_CLEAR}"
    return 1
  fi

  ish_stream_stderr "${ISH_TUI_WARN}${message}${ISH_TUI_CLEAR}"
}

ish_tui_quiet() {
  "${1-}" > /dev/null
}

ish_tui_confirm() {
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

ish_tui_help() {
  cat >&2 <<EOF
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

ish_tui_route() {
  case "${1-}" in
    info)
      shift
      ish_tui_info "$@"
      ;;
    warn)
      shift
      ish_tui_warn "$@"
      ;;
    error)
      shift
      ish_tui_error "$@"
      ;;
    confirm)
      shift
      ish_tui_confirm "$@"
      ;;
    set-colors)
      ish_tui_set_colors
      ;;
    template)
      shift
      case "${1-}" in
        file)
          shift
          ish_tui_template_file "$@"
          ;;
        "")
          cat >&2 <<EOF
usage: ish tui template [command]

commands:
  file --path=PATH    output template file contents
EOF
          ;;
        *)
          ish_tui_error --message="unknown tui template command: ${1-}"
          ;;
      esac
      ;;
    help|"")
      ish_tui_help
      ;;
    *)
      ish_tui_error --message="unknown tui command: ${1-}"
      ;;
  esac
}
