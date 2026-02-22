#!/usr/bin/env bash

# Primitive layer. Built on file_descriptor.
# Result combinators for single command outcomes: and_then, or_else, map.
# Names the FP computation patterns that bash spells with && and ||.

ish_result_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ish_result_module_dir}/file_descriptor.sh"

ish_result_and_then() {
  local func

  [[ $# -eq 0 ]] && _result_error "at least one function required"

  for func in "$@"; do
    "$func" || return $?
  done
}

ish_result_map() {
  local cmd="${1-}"
  local transform="${2-}"

  [[ -z "$cmd" ]] && _result_error "command function required as first argument"
  [[ -z "$transform" ]] && _result_error "transform function required as second argument"

  local output
  output=$("$cmd") || return $?
  "$transform" "$output"
}

ish_result_or_else() {
  local primary="${1-}"
  local fallback="${2-}"

  [[ -z "$primary" ]] && _result_error "primary function required as first argument"
  [[ -z "$fallback" ]] && _result_error "fallback function required as second argument"

  "$primary" || "$fallback"
}

# Private functions

_result_error() {
  printf '%s\n' "${ISH_COLOR_RED}ish_result: ${1}${ISH_COLOR_CLEAR}" >&2
  exit 1
}
