#!/usr/bin/env bash

dotfiles_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_PACKAGES_DIR}/ish/source/utils/tui.sh"
source "${ISH_PACKAGES_DIR}/ish/source/utils.sh"

source "${dotfiles_module_dir}/test.sh"
source "${dotfiles_module_dir}/lint.sh"
source "${dotfiles_module_dir}/bootstrap.sh"
source "${dotfiles_module_dir}/git.sh"
source "${dotfiles_module_dir}/nix.sh"

dotfiles_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish dotfiles [command]

dotfiles package - configuration and environment management

commands:
  bootstrap    setup development environment
  git          git utility functions
  lint         run linters for dotfiles package
  nix          nix package manager utilities
  test         run tests for dotfiles package
EOF
}

dotfiles_route() {
  case "${1-}" in
  test)
    shift
    dotfiles_test_route "$@"
    ;;
  lint)
    shift
    dotfiles_lint_route "$@"
    ;;
  bootstrap)
    shift
    bootstrap_route "$@"
    ;;
  git)
    shift
    git_route "$@"
    ;;
  nix)
    shift
    ish_dotfiles_nix_route "$@"
    ;;
  help|"")
    dotfiles_help
    ;;
  *)
    dotfiles_help
    ish_utils_tui_error --message="unknown dotfiles command: ${1-}"
    return 1
    ;;
  esac
}
