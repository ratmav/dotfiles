#!/usr/bin/env bash

ish_dotfiles_bootstrap_macos_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_PACKAGES_DIR}/ish/source/utils/tui.sh"
source "${ISH_PACKAGES_DIR}/ish/source/platform.sh"
source "${ISH_PACKAGES_DIR}/ish/source/utils.sh"
source "${ish_dotfiles_bootstrap_macos_module_dir}/posix.sh"

source "${ish_dotfiles_bootstrap_macos_module_dir}/macos/homebrew.sh"
source "${ish_dotfiles_bootstrap_macos_module_dir}/macos/bash.sh"

ish_dotfiles_bootstrap_macos_all() {
  ish_dotfiles_bootstrap_macos_homebrew_install
  ish_dotfiles_bootstrap_macos_homebrew_brew
  ish_dotfiles_bootstrap_macos_homebrew_cask
  ish_dotfiles_bootstrap_macos_bash
  ish_dotfiles_bootstrap_posix_all
}

ish_dotfiles_bootstrap_macos_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish dotfiles bootstrap macos [command]

commands:
  all          run all macos bootstrap steps
  homebrew     manage homebrew and packages
  bash         configure bash as default shell
EOF
}

ish_dotfiles_bootstrap_macos_route() {
  case "${1-}" in
  all)
    ish_dotfiles_bootstrap_macos_all
    ;;
  homebrew)
    shift
    case "${1-}" in
      all)
        ish_dotfiles_bootstrap_macos_homebrew_install
        ish_dotfiles_bootstrap_macos_homebrew_brew
        ish_dotfiles_bootstrap_macos_homebrew_cask
        ;;
      install)
        shift
        ish_dotfiles_bootstrap_macos_homebrew_install
        ;;
      brew)
        shift
        ish_dotfiles_bootstrap_macos_homebrew_brew
        ;;
      cask)
        shift
        ish_dotfiles_bootstrap_macos_homebrew_cask
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
    ish_dotfiles_bootstrap_macos_bash
    ;;
  help|"")
    ish_dotfiles_bootstrap_macos_help
    ;;
  *)
    ish_dotfiles_bootstrap_macos_help
    ish_utils_tui_error --message="unknown macos subcommand: ${1-}"
    ;;
  esac
}
