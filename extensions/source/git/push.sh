#!/usr/bin/env bash

# git push operation
#
# dependencies: ish_git_error, ish_git_require
# these functions are available because git.sh sources dependencies before this module

ish_git_push() {
  local dir=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --dir=*) dir="${1#*=}"; shift ;;
      *) ish_git_error "push: unknown option: $1" ;;
    esac
  done

  [[ -z "$dir" ]] && ish_git_error "push: --dir= required"

  ish_git_require --dir="$dir"

  git -C "$dir" push \
    || ish_git_error "push failed in $dir — resolve conflicts manually and push"
}
