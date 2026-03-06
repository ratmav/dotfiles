#!/usr/bin/env bash

# git add operation
#
# dependencies: ish_git_error, ish_git_require
# these functions are available because git.sh sources dependencies before this module

ish_git_add() {
  local dir=""
  local path=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --dir=*) dir="${1#*=}"; shift ;;
      --path=*) path="${1#*=}"; shift ;;
      *) ish_git_error "add: unknown option: $1" ;;
    esac
  done

  [[ -z "$dir" ]] && ish_git_error "add: --dir= required"
  [[ -z "$path" ]] && ish_git_error "add: --path= required"

  ish_git_require --dir="$dir"

  git -C "$dir" add "$path" \
    || ish_git_error "add failed for '$path' in $dir"
}
