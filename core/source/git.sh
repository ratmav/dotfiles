#!/usr/bin/env bash

# Integration layer. Wraps git binary.
# Composes stream primitives around shell calls to git.
# All functions accept --dir= to target a specific repo (uses git -C).

ish_git_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ish_git_module_dir}/exists.sh"
source "${ish_git_module_dir}/stream.sh"

ish_git_add() {
  local dir=""
  local path=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --dir=*) dir="${1#*=}"; shift ;;
      --path=*) path="${1#*=}"; shift ;;
      *) _git_error "add: unknown option: $1" ;;
    esac
  done

  [[ -z "$dir" ]] && _git_error "add: --dir= required"
  [[ -z "$path" ]] && _git_error "add: --path= required"

  ish_git_require --dir="$dir"

  git -C "$dir" add "$path" \
    || _git_error "add failed for '$path' in $dir"
}

ish_git_commit() {
  local dir=""
  local message=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --dir=*) dir="${1#*=}"; shift ;;
      --message=*) message="${1#*=}"; shift ;;
      *) _git_error "commit: unknown option: $1" ;;
    esac
  done

  [[ -z "$dir" ]] && _git_error "commit: --dir= required"
  [[ -z "$message" ]] && _git_error "commit: --message= required"

  ish_git_require --dir="$dir"

  git -C "$dir" commit -m "$message" \
    || _git_error "commit failed in $dir — nothing staged or hook failure"
}

ish_git_pull() {
  local dir=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --dir=*) dir="${1#*=}"; shift ;;
      *) _git_error "pull: unknown option: $1" ;;
    esac
  done

  [[ -z "$dir" ]] && _git_error "pull: --dir= required"

  ish_git_require --dir="$dir"

  git -C "$dir" pull \
    || _git_error "pull failed in $dir — resolve conflicts or check network"
}

ish_git_push() {
  local dir=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --dir=*) dir="${1#*=}"; shift ;;
      *) _git_error "push: unknown option: $1" ;;
    esac
  done

  [[ -z "$dir" ]] && _git_error "push: --dir= required"

  ish_git_require --dir="$dir"

  git -C "$dir" push \
    || _git_error "push failed in $dir — resolve conflicts manually and push"
}

ish_git_require() {
  local dir=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --dir=*) dir="${1#*=}"; shift ;;
      *) _git_error "require: unknown option: $1" ;;
    esac
  done

  [[ -z "$dir" ]] && _git_error "require: --dir= required"

  ish_exists_executable --executable=git \
    || _git_error "git not found. install git."

  git -C "$dir" rev-parse --git-dir > /dev/null 2>&1 \
    || _git_error "not a git repository: $dir"
}

# Private functions

_git_error() {
  ish_stream_stderr "${ISH_COLOR_RED}ish_git: ${1}${ISH_COLOR_CLEAR}"
  exit 1
}
