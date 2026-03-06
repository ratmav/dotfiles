#!/usr/bin/env bash

# sqlite query operation (read statements, pipe-delimited)
#
# dependencies: ish_sqlite3_error, ish_sqlite3_require
# these functions are available because sqlite3.sh sources dependencies before this module

ish_sqlite3_query() {
  local db=""
  local sql=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      --sql=*) sql="${1#*=}"; shift ;;
      *) ish_sqlite3_error "query: unknown option: $1" ;;
    esac
  done

  [[ -z "$db" ]] && ish_sqlite3_error "query: --db= required"
  [[ -z "$sql" ]] && ish_sqlite3_error "query: --sql= required"

  ish_sqlite3_require

  sqlite3 -separator '|' "$db" "PRAGMA foreign_keys = ON; ${sql}" \
    || ish_sqlite3_error "query failed: ${sql}"
}
