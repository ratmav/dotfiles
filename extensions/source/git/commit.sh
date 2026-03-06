#!/usr/bin/env bash

# git commit operation
#
# dependencies: ish_git_error, ish_git_require
# these functions are available because git.sh sources dependencies before this module

ish_git_commit() {
  local dir=""
  local message=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --dir=*) dir="${1#*=}"; shift ;;
      --message=*) message="${1#*=}"; shift ;;
      *) ish_git_error "commit: unknown option: $1" ;;
    esac
  done

  [[ -z "$dir" ]] && ish_git_error "commit: --dir= required"
  [[ -z "$message" ]] && ish_git_error "commit: --message= required"

  ish_git_require --dir="$dir"

  git -C "$dir" commit -m "$message" \
    || ish_git_error "commit failed in $dir — nothing staged or hook failure"
}
