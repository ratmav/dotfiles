#!/usr/bin/env bash

# sqlite load operation (import SQL from stdin)
#
# dependencies: ish_sqlite3_error, ish_sqlite3_require
# these functions are available because sqlite3.sh sources dependencies before this module

ish_sqlite3_load() {
  local db=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      *) ish_sqlite3_error "load: unknown option: $1" ;;
    esac
  done

  [[ -z "$db" ]] && ish_sqlite3_error "load: --db= required"

  ish_sqlite3_require

  sqlite3 "$db" \
    || ish_sqlite3_error "load failed"
}
