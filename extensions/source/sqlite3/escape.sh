#!/usr/bin/env bash

# sqlite string escaping
#
# no dependencies — pure string operation

ish_sqlite3_escape() {
  local value="${1-}"
  printf '%s' "${value//\'/\'\'}"
}
