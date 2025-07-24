#!/usr/bin/env bash

tui_error() {
  local message=$1
  tui_msg "${TUI_ERROR}$message"
}

tui_info() {
  local message=$1
  tui_msg "${TUI_INFO}$message"
}

tui_template() {
  local level=$1
  local template=$2
  shift 2

  # Replace named placeholders with key value pairs
  while [[ $# -gt 1 ]]; do
    local key=$1
    local value=$2
    template=${template//\{\{$key\}\}/$value}
    shift 2
  done

  # Use tui_msg with the specified level
  tui_msg "${level}${template}"
}

tui_msg() {
  # TUI_CLEAR restores colors.
  echo >&2 -e "${1-}${TUI_CLEAR}"
}

tui_msg_init() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    # error: read; clear: restore colors, info: white, warn: orange.
    # shellcheck disable=SC2034
    TUI_ERROR='\033[0;31m' TUI_CLEAR='\033[0m' TUI_INFO='\033[0;32m' TUI_WARN='\033[0;33m'
  else
    # shellcheck disable=SC2034
    TUI_ERROR='' TUI_CLEAR='' TUI_INFO='' TUI_WARN=''
  fi
}

tui_quiet() {
  $1 > /dev/null
}

tui_warn() {
  local message=$1
  tui_msg "${TUI_WARN}$message"
}
