#!/usr/bin/env bash

# Integration layer. Wraps sqlite3 binary.
# Composes stream + file primitives around shell calls to sqlite3.

ish_sqlite_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ish_sqlite_module_dir}/exists.sh"

ish_sqlite_require() {
  ish_exists_executable --executable=sqlite3 \
    || _sqlite_error "sqlite3 not found. install sqlite3."
}

# Private functions

_sqlite_error() {
  printf '%s\n' "${ISH_COLOR_RED}ish_sqlite: ${1}${ISH_COLOR_CLEAR}" >&2
  exit 1
}
