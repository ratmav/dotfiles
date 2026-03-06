#!/usr/bin/env bash

# git pull operation
#
# dependencies: ish_git_error, ish_git_require
# these functions are available because git.sh sources dependencies before this module

ish_git_pull() {
  local dir=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --dir=*) dir="${1#*=}"; shift ;;
      *) ish_git_error "pull: unknown option: $1" ;;
    esac
  done

  [[ -z "$dir" ]] && ish_git_error "pull: --dir= required"

  ish_git_require --dir="$dir"

  git -C "$dir" pull \
    || ish_git_error "pull failed in $dir — resolve conflicts or check network"
}
