#!/usr/bin/env bash

ish_platform_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ish_platform_module_dir}/tui.sh"
source "${ish_platform_module_dir}/file.sh"

# Public functions (alphabetized)

ish_platform_arch() {
  local machine=$(uname -m)
  case "$machine" in
    x86_64|amd64)
      ish_stream_stdout "amd64"
      ;;
    aarch64|arm64)
      ish_stream_stdout "arm64"
      ;;
    *)
      ish_stream_stdout "$machine"
      ;;
  esac
}

ish_platform_help() {
  ish_stream_stdout "usage: ish platform [command]"
  ish_stream_stdout ""
  ish_stream_stdout "commands:"
  ish_stream_stdout "  arch         output architecture (arm64, amd64)"
  ish_stream_stdout "  os           output operating system (macos, kali)"
}

ish_platform_os() {
  if _platform_is_macos; then
    ish_stream_stdout "macos"
  elif _platform_is_kali; then
    ish_stream_stdout "kali"
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
  if ish_file_exists --path=/etc/issue; then
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
