#!/usr/bin/env bash

bootstrap_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_PACKAGES_DIR}/ish/source/utils/tui.sh"
source "${ISH_PACKAGES_DIR}/ish/source/platform.sh"

bootstrap_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish dotfiles bootstrap [platform]

platforms:
  all      auto-detect and bootstrap current platform
  macos    bootstrap macos system
  kali     bootstrap kali linux system
  posix    bootstrap posix-compatible tools
EOF
}

bootstrap_route() {
  case "${1-}" in
    all)
      # ish_platform_os errors and exits for unsupported platforms
      os=$(ish_platform_os)

      case "$os" in
        macos)
          source "${bootstrap_module_dir}/bootstrap/macos.sh"
          bootstrap_macos_all
          ;;
        kali)
          source "${bootstrap_module_dir}/bootstrap/kali.sh"
          bootstrap_kali_all
          ;;
      esac
      ;;
    macos)
      shift
      source "${bootstrap_module_dir}/bootstrap/macos.sh"
      bootstrap_macos_route "$@"
      ;;
    kali)
      shift
      source "${bootstrap_module_dir}/bootstrap/kali.sh"
      bootstrap_kali_route "$@"
      ;;
    posix)
      shift
      source "${bootstrap_module_dir}/bootstrap/posix.sh"
      bootstrap_posix_route "$@"
      ;;
    help|"")
      bootstrap_help
      ;;
    *)
      bootstrap_help
      ish_utils_tui_error --message="unknown bootstrap platform: ${1-}"
      ;;
  esac
}
