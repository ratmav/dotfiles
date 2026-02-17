#!/usr/bin/env bash

ish_ratfiles_bootstrap_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_CORE}/source/tui.sh"
source "${ISH_CORE}/source/platform.sh"
source "${ish_ratfiles_bootstrap_module_dir}/bootstrap/macos.sh"
source "${ish_ratfiles_bootstrap_module_dir}/bootstrap/kali.sh"
source "${ish_ratfiles_bootstrap_module_dir}/bootstrap/posix.sh"

ish_ratfiles_bootstrap_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish ratfiles bootstrap [platform]

platforms:
  all      auto-detect and bootstrap current platform
  macos    bootstrap macos system
  kali     bootstrap kali linux system
  posix    bootstrap posix-compatible tools
EOF
}

ish_ratfiles_bootstrap_route() {
  case "${1-}" in
    all)
      # ish_platform_os errors and exits for unsupported platforms
      os=$(ish_platform_os)

      case "$os" in
        macos)
          ish_ratfiles_bootstrap_macos_all
          ;;
        kali)
          ish_ratfiles_bootstrap_kali_all
          ;;
      esac
      ;;
    macos)
      shift
      ish_ratfiles_bootstrap_macos_route "$@"
      ;;
    kali)
      shift
      ish_ratfiles_bootstrap_kali_route "$@"
      ;;
    posix)
      shift
      ish_ratfiles_bootstrap_posix_route "$@"
      ;;
    help|"")
      ish_ratfiles_bootstrap_help
      ;;
    *)
      ish_ratfiles_bootstrap_help
      ish_tui_error --message="unknown bootstrap platform: ${1-}"
      ;;
  esac
}
