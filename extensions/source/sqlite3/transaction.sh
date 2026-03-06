#!/usr/bin/env bash

# sqlite transaction operation (atomic multi-statement execution)
#
# dependencies: ish_sqlite3_error, ish_sqlite3_require, ish_stream_read
# these functions are available because sqlite3.sh sources dependencies before this module

ish_sqlite3_transaction() {
  local db=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      *) ish_sqlite3_error "transaction: unknown option: $1" ;;
    esac
  done

  [[ -z "$db" ]] && ish_sqlite3_error "transaction: --db= required"

  ish_sqlite3_require

  local sql
  sql=$(ish_stream_read) || ish_sqlite3_error "transaction: failed to read stdin"

  sqlite3 "$db" "PRAGMA foreign_keys = ON; BEGIN; ${sql} COMMIT;" \
    || ish_sqlite3_error "transaction failed, rolled back"
}
