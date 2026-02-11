#!/usr/bin/env bash

ish_ratfiles_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_CORE}/source/utils/tui.sh"
source "${ISH_CORE}/source/utils.sh"

source "${ish_ratfiles_module_dir}/test.sh"
source "${ish_ratfiles_module_dir}/lint.sh"
source "${ish_ratfiles_module_dir}/bootstrap.sh"
source "${ish_ratfiles_module_dir}/git.sh"
source "${ish_ratfiles_module_dir}/nix.sh"

ish_ratfiles_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish ratfiles [command]

dotfiles package - configuration and environment management

commands:
  bootstrap    setup development environment
  git          git utility functions
  lint         run linters for dotfiles package
  nix          nix package manager utilities
  test         run tests for dotfiles package
EOF
}

ish_ratfiles_route() {
  case "${1-}" in
  test)
    shift
    ish_ratfiles_test_route "$@"
    ;;
  lint)
    shift
    ish_ratfiles_lint_route "$@"
    ;;
  bootstrap)
    shift
    ish_ratfiles_bootstrap_route "$@"
    ;;
  git)
    shift
    ish_ratfiles_git_route "$@"
    ;;
  nix)
    shift
    ish_ratfiles_nix_route "$@"
    ;;
  help|"")
    ish_ratfiles_help
    ;;
  *)
    ish_ratfiles_help
    ish_utils_tui_error --message="unknown dotfiles command: ${1-}"
    return 1
    ;;
  esac
}
