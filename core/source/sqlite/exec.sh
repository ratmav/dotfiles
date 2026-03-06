#!/usr/bin/env bash

# sqlite exec operation (write statements)
#
# dependencies: ish_sqlite_error, ish_sqlite_require
# these functions are available because sqlite.sh sources dependencies before this module

ish_sqlite_exec() {
  local db=""
  local sql=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      --sql=*) sql="${1#*=}"; shift ;;
      *) ish_sqlite_error "exec: unknown option: $1" ;;
    esac
  done

  [[ -z "$db" ]] && ish_sqlite_error "exec: --db= required"
  [[ -z "$sql" ]] && ish_sqlite_error "exec: --sql= required"

  ish_sqlite_require

  sqlite3 "$db" "PRAGMA foreign_keys = ON; ${sql}" \
    || ish_sqlite_error "exec failed: ${sql}"
}
