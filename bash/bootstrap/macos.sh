#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd -P)
bootstrap_macos_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${script_dir}/bash/utils/tui.sh"
source "${script_dir}/bash/platform.sh"
source "${script_dir}/bash/utils.sh"
source "${script_dir}/bash/bootstrap/posix.sh"

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
  utils_stream_multiline_stderr <<EOF
usage: ish bootstrap macos [command]

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
      "")
        utils_tui_info --message="usage: ish bootstrap macos homebrew [command]"
        utils_tui_info --message=""
        utils_tui_info --message="commands:"
        utils_tui_info --message="  all       run all homebrew setup steps"
        utils_tui_info --message="  install   install homebrew"
        utils_tui_info --message="  brew      install brew packages"
        utils_tui_info --message="  cask      install cask packages"
        ;;
      *)
        utils_tui_error --message="unknown homebrew subcommand: ${1-}"
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
    utils_tui_error --message="unknown macos subcommand: ${1-}"
    ;;
  esac
}
