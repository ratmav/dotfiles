#!/usr/bin/env bash

# sqlite dump operation (export data as INSERT statements)
#
# dependencies: ish_sqlite_error, ish_file_exists, ish_sqlite_require, ish_stream_filter, ish_stream_stdout
# these functions are available because sqlite.sh sources dependencies before this module

ish_sqlite_dump() {
  local db=""
  local tables=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      --tables=*) tables="${1#*=}"; shift ;;
      *) ish_sqlite_error "dump: unknown option: $1" ;;
    esac
  done

  [[ -z "$db" ]] && ish_sqlite_error "dump: --db= required"
  ish_file_exists --path="$db" \
    || ish_sqlite_error "dump: database not found: ${db}"

  ish_sqlite_require

  local result
  result=$(sqlite3 "$db" ".dump ${tables}" | ish_stream_filter _sqlite_is_insert)

  [[ -z "$result" ]] && ish_sqlite_error "dump: no data to export"

  ish_stream_stdout "$result"
}

# Private functions

_sqlite_is_insert() { [[ "$1" == INSERT* ]]; }
