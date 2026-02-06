#!/usr/bin/env bash

_platform_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${_platform_dir}/utils.sh"

# Public functions (alphabetized)

platform_arch() {
  local machine=$(uname -m)
  case "$machine" in
    x86_64|amd64)
      utils_stream_stdout "amd64"
      ;;
    aarch64|arm64)
      utils_stream_stdout "arm64"
      ;;
    *)
      utils_stream_stdout "$machine"
      ;;
  esac
}

platform_help() {
  utils_stream_stdout "usage: ish platform [command]"
  utils_stream_stdout ""
  utils_stream_stdout "commands:"
  utils_stream_stdout "  arch         output architecture (arm64, amd64)"
  utils_stream_stdout "  os           output operating system (macos, kali)"
}

platform_os() {
  if _platform_is_macos; then
    utils_stream_stdout "macos"
  elif _platform_is_kali; then
    utils_stream_stdout "kali"
  else
    utils_tui_error --message="unsupported platform"
  fi
}

# Routing function - explicitly dispatches commands to functions.
# See bash/tui.sh for documentation on why we use explicit routing.
platform_route() {
  case "${1-}" in
    arch)
      platform_arch
      ;;
    os)
      platform_os
      ;;
    help|"")
      platform_help
      ;;
    *)
      utils_tui_error --message="unknown platform command: ${1-}"
      ;;
  esac
}

# Private functions (alphabetized)

_platform_is_kali() {
  if utils_exists_file --file=/etc/issue; then
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
