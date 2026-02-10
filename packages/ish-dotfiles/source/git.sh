#!/usr/bin/env bash

git_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_PACKAGES_DIR}/ish/source/utils/tui.sh"

source "${git_module_dir}/git/clean.sh"

git_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish dotfiles git [command]

commands:
  clean        remove cruft and maintain clean state
EOF
}

git_route() {
  case "${1-}" in
    clean)
      shift
      case "${1-}" in
        prune)
          shift
          git_clean_prune "$@"
          ;;
        worktrees)
          shift
          git_clean_worktrees "$@"
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
      git_help
      ;;
    *)
      ish_utils_tui_error --message="unknown git command: ${1-}"
      git_help
      return 1
      ;;
  esac
}
