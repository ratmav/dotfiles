#!/usr/bin/env bash

# sqlite load operation (import SQL from stdin)
#
# dependencies: ish_sqlite_error, ish_sqlite_require
# these functions are available because sqlite.sh sources dependencies before this module

ish_sqlite_load() {
  local db=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      *) ish_sqlite_error "load: unknown option: $1" ;;
    esac
  done

  [[ -z "$db" ]] && ish_sqlite_error "load: --db= required"

  ish_sqlite_require

  sqlite3 "$db" \
    || ish_sqlite_error "load failed"
}
