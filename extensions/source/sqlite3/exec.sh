#!/usr/bin/env bash

# sqlite exec — execute SQL with native parameter binding
#
# dependencies: ish_sqlite3_error, ish_sqlite3_require, ish_sqlite3_build_params_stdin
# these functions are available because sqlite3.sh sources dependencies before this module

ish_sqlite3_exec() {
  local db=""
  local sql=""
  local separator=""
  local params=()

  while [[ $# -gt 0 ]]; do
    case $1 in
      --db=*) db="${1#*=}"; shift ;;
      --sql=*) sql="${1#*=}"; shift ;;
      --separator=*) separator="${1#*=}"; shift ;;
      *) params+=("$1"); shift ;;
    esac
  done

  [[ -z "$db" ]] && ish_sqlite3_error "exec: --db= required"
  [[ -z "$sql" ]] && ish_sqlite3_error "exec: --sql= required"

  ish_sqlite3_require

  local separator_args=()
  [[ -n "$separator" ]] && separator_args=(-separator "$separator")

  {
    [[ ${#params[@]} -gt 0 ]] && ish_sqlite3_build_params_stdin "${params[@]}"
    printf '%s\n' "PRAGMA foreign_keys = ON; ${sql}"
  } | sqlite3 "${separator_args[@]}" "$db" \
    || ish_sqlite3_error "exec failed: ${sql}"
}
