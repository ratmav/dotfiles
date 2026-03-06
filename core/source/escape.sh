#!/usr/bin/env bash

# Foundation layer. No dependencies.
# Apply an escaping strategy to a value for safe passage across external boundaries.
# Extensions provide strategy functions; this atom applies them.

ish_escape() {
  local strategy="${1-}"
  local value="${2-}"

  [[ -z "$strategy" ]] && _escape_error "strategy function required as first argument"

  "$strategy" "$value"
}

# Private functions

_escape_error() {
  printf '%s\n' "ish_escape: ${1}" >&2
  exit 1
}
