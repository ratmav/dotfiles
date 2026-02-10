#!/usr/bin/env bash

ish_dotfiles_git_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_PACKAGES_DIR}/ish/source/utils/tui.sh"

source "${ish_dotfiles_git_module_dir}/git/clean.sh"

ish_dotfiles_git_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish dotfiles git [command]

commands:
  clean        remove cruft and maintain clean state
EOF
}

ish_dotfiles_git_route() {
  case "${1-}" in
    clean)
      shift
      case "${1-}" in
        prune)
          shift
          ish_dotfiles_git_clean_prune "$@"
          ;;
        worktrees)
          shift
          ish_dotfiles_git_clean_worktrees "$@"
          ;;
        help|"")
          ish_utils_stream_multiline_stderr <<EOF
usage: ish dotfiles git clean [command]

commands:
  prune        prune local branches missing on remote
  worktrees    remove all worktrees except main
EOF
          ;;
        *)
          ish_utils_tui_error --message="unknown git clean command: ${1-}"
          return 1
          ;;
      esac
      ;;
    help|"")
      ish_dotfiles_git_help
      ;;
    *)
      ish_utils_tui_error --message="unknown git command: ${1-}"
      ish_dotfiles_git_help
      return 1
      ;;
  esac
}
