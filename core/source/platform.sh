#!/usr/bin/env bash

_platform_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${_platform_dir}/utils.sh"

# Public functions (alphabetized)

ish_platform_arch() {
  local machine=$(uname -m)
  case "$machine" in
    x86_64|amd64)
      ish_utils_stream_stdout "amd64"
      ;;
    aarch64|arm64)
      ish_utils_stream_stdout "arm64"
      ;;
    *)
      ish_utils_stream_stdout "$machine"
      ;;
  esac
}

ish_platform_help() {
  ish_utils_stream_stdout "usage: ish platform [command]"
  ish_utils_stream_stdout ""
  ish_utils_stream_stdout "commands:"
  ish_utils_stream_stdout "  arch         output architecture (arm64, amd64)"
  ish_utils_stream_stdout "  os           output operating system (macos, kali)"
}

ish_platform_os() {
  if _platform_is_macos; then
    ish_utils_stream_stdout "macos"
  elif _platform_is_kali; then
    ish_utils_stream_stdout "kali"
  else
    ish_tui_error --message="unsupported platform"
  fi
}

# Routing function - explicitly dispatches commands to functions.
# See bash/tui.sh for documentation on why we use explicit routing.
ish_platform_route() {
  case "${1-}" in
    arch)
      ish_platform_arch
      ;;
    os)
      ish_platform_os
      ;;
    help|"")
      ish_platform_help
      ;;
    *)
      ish_tui_error --message="unknown platform command: ${1-}"
      ;;
  esac
}

# Private functions (alphabetized)

_platform_is_kali() {
  if ish_utils_exists_file --file=/etc/issue; then
    if grep -q "Kali" /etc/issue; then
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

_platform_is_macos() {
  [[ $(uname) == "Darwin" ]]
}
