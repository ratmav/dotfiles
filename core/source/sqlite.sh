#!/usr/bin/env bash

# Integration layer. Wraps sqlite3 binary.
# Composes stream + file primitives around shell calls to sqlite3.

ish_sqlite_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ish_sqlite_module_dir}/exists.sh"

ish_sqlite_exec() {
  local db=""
  local sql=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      --sql=*) sql="${1#*=}"; shift ;;
      *) _sqlite_error "exec: unknown option: $1" ;;
    esac
  done

  [[ -z "$db" ]] && _sqlite_error "exec: --db= required"
  [[ -z "$sql" ]] && _sqlite_error "exec: --sql= required"

  ish_sqlite_require

  sqlite3 "$db" "PRAGMA foreign_keys = ON; ${sql}" \
    || _sqlite_error "exec failed: ${sql}"
}

ish_sqlite_query() {
  local db=""
  local sql=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      --sql=*) sql="${1#*=}"; shift ;;
      *) _sqlite_error "query: unknown option: $1" ;;
    esac
  done

  [[ -z "$db" ]] && _sqlite_error "query: --db= required"
  [[ -z "$sql" ]] && _sqlite_error "query: --sql= required"

  ish_sqlite_require

  sqlite3 -separator '|' "$db" "PRAGMA foreign_keys = ON; ${sql}" \
    || _sqlite_error "query failed: ${sql}"
}

ish_sqlite_query_one() {
  local db=""
  local sql=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      --sql=*) sql="${1#*=}"; shift ;;
      *) _sqlite_error "query_one: unknown option: $1" ;;
    esac
  done

  [[ -z "$db" ]] && _sqlite_error "query_one: --db= required"
  [[ -z "$sql" ]] && _sqlite_error "query_one: --sql= required"

  local output
  output=$(ish_sqlite_query --db="$db" --sql="$sql") || return $?

  local count
  count=$(printf '%s\n' "$output" | grep -c '.')

  [[ "$count" -eq 0 ]] && _sqlite_error "query_one: no rows returned"
  [[ "$count" -gt 1 ]] && _sqlite_error "query_one: expected 1 row, got ${count}"

  printf '%s\n' "$output"
}

ish_sqlite_transaction() {
  local db=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      *) _sqlite_error "transaction: unknown option: $1" ;;
    esac
  done

  [[ -z "$db" ]] && _sqlite_error "transaction: --db= required"

  ish_sqlite_require

  local sql
  sql=$(cat) || _sqlite_error "transaction: failed to read stdin"

  sqlite3 "$db" "PRAGMA foreign_keys = ON; BEGIN; ${sql} COMMIT;" \
    || _sqlite_error "transaction failed, rolled back"
}

ish_sqlite_dump() {
  local db=""
  local tables=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      --tables=*) tables="${1#*=}"; shift ;;
      *) _sqlite_error "dump: unknown option: $1" ;;
    esac
  done

  [[ -z "$db" ]] && _sqlite_error "dump: --db= required"
  [[ -f "$db" ]] || _sqlite_error "dump: database not found: ${db}"

  ish_sqlite_require

  sqlite3 "$db" ".dump ${tables}" | grep '^INSERT' \
    || _sqlite_error "dump: no data to export"
}

ish_sqlite_load() {
  local db=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      *) _sqlite_error "load: unknown option: $1" ;;
    esac
  done

  [[ -z "$db" ]] && _sqlite_error "load: --db= required"

  ish_sqlite_require

  sqlite3 "$db" \
    || _sqlite_error "load failed"
}

ish_sqlite_require() {
  ish_exists_executable --executable=sqlite3 \
    || _sqlite_error "sqlite3 not found. install sqlite3."
}

# Private functions

_sqlite_error() {
  printf '%s\n' "${ISH_COLOR_RED}ish_sqlite: ${1}${ISH_COLOR_CLEAR}" >&2
  exit 1
}
