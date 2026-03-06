#!/usr/bin/env bash

# sqlite string escaping (SQL single-quote doubling)
#
# use for identifiers only (table names, column names) — these cannot be parameterized.
# for values, use ? placeholders with positional args to ish_sqlite3_exec.
#
# no dependencies — pure string operation

ish_sqlite3_escape() {
  local value="${1-}"
  printf '%s' "${value//\'/\'\'}"
}
