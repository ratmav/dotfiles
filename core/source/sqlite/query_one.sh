#!/usr/bin/env bash

# sqlite single-row query operation
#
# dependencies: ish_sqlite_error, ish_sqlite_query, ish_stream_fold, ish_stream_stdout
# these functions are available because sqlite.sh sources dependencies before this module

ish_sqlite_query_one() {
  local db=""
  local sql=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      --sql=*) sql="${1#*=}"; shift ;;
      *) ish_sqlite_error "query_one: unknown option: $1" ;;
    esac
  done

  [[ -z "$db" ]] && ish_sqlite_error "query_one: --db= required"
  [[ -z "$sql" ]] && ish_sqlite_error "query_one: --sql= required"

  local output
  output=$(ish_sqlite_query --db="$db" --sql="$sql") || return $?

  [[ -z "$output" ]] && ish_sqlite_error "query_one: no rows returned"

  local count
  count=$(printf '%s\n' "$output" | ish_stream_fold _sqlite_count_line 0)
  [[ "$count" -gt 1 ]] && ish_sqlite_error "query_one: expected 1 row, got ${count}"

  ish_stream_stdout "$output"
}

# Private functions

_sqlite_count_line() { echo $(( $1 + 1 )); }
