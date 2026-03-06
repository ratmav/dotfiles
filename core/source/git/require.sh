#!/usr/bin/env bash

# git repository validation
#
# dependencies: ish_exists_executable, ish_git_error
# these functions are available because git.sh sources dependencies before this module

ish_git_require() {
  local dir=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --dir=*) dir="${1#*=}"; shift ;;
      *) ish_git_error "require: unknown option: $1" ;;
    esac
  done

  [[ -z "$dir" ]] && ish_git_error "require: --dir= required"

  ish_exists_executable --executable=git \
    || ish_git_error "git not found. install git."

  git -C "$dir" rev-parse --git-dir > /dev/null 2>&1 \
    || ish_git_error "not a git repository: $dir"
}
