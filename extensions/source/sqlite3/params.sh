#!/usr/bin/env bash

# sqlite3 parameter binding
#
# dependencies: ish_escape
# these functions are available because sqlite3.sh sources dependencies before this module

ish_sqlite3_build_params_stdin() {
  local i=1
  local escaped

  while [[ $# -gt 0 ]]; do
    escaped=$(ish_escape _ish_sqlite3_escape_param "$1")
    printf '.parameter set ?%d "%s"\n' "$i" "$escaped"
    i=$((i + 1))
    shift
  done
}

# Private functions

_ish_sqlite3_escape_param() {
  local value="$1"
  local escaped="${value//\\/\\\\}"
  escaped="${escaped//\"/\\\"}"
  printf '%s' "$escaped"
}
