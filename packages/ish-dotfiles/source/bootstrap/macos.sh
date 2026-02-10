#!/usr/bin/env bash

bootstrap_macos_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_PACKAGES_DIR}/ish/source/utils/tui.sh"
source "${ISH_PACKAGES_DIR}/ish/source/platform.sh"
source "${ISH_PACKAGES_DIR}/ish/source/utils.sh"
source "${bootstrap_macos_module_dir}/posix.sh"

source "${bootstrap_macos_module_dir}/macos/homebrew.sh"
source "${bootstrap_macos_module_dir}/macos/bash.sh"

bootstrap_macos_all() {
  bootstrap_macos_homebrew_install
  bootstrap_macos_homebrew_brew
  bootstrap_macos_homebrew_cask
  bootstrap_macos_bash
  bootstrap_posix_all
}

bootstrap_macos_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish dotfiles bootstrap macos [command]

commands:
  all          run all macos bootstrap steps
  homebrew     manage homebrew and packages
  bash         configure bash as default shell
EOF
}

bootstrap_macos_route() {
  case "${1-}" in
  all)
    bootstrap_macos_all
    ;;
  homebrew)
    shift
    case "${1-}" in
      all)
        bootstrap_macos_homebrew_install
        bootstrap_macos_homebrew_brew
        bootstrap_macos_homebrew_cask
        ;;
      install)
        shift
        bootstrap_macos_homebrew_install
        ;;
      brew)
        shift
        bootstrap_macos_homebrew_brew
        ;;
      cask)
        shift
        bootstrap_macos_homebrew_cask
        ;;
      help|"")
        ish_utils_stream_multiline_stderr <<EOF
usage: ish dotfiles bootstrap macos homebrew [command]

commands:
  all       run all homebrew setup steps
  install   install homebrew
  brew      install brew packages
  cask      install cask packages
EOF
        ;;
      *)
        ish_utils_tui_error --message="unknown homebrew subcommand: ${1-}"
        ;;
    esac
    ;;
  bash)
    shift
    bootstrap_macos_bash
    ;;
  help|"")
    bootstrap_macos_help
    ;;
  *)
    bootstrap_macos_help
    ish_utils_tui_error --message="unknown macos subcommand: ${1-}"
    ;;
  esac
}
