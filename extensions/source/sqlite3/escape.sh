#!/usr/bin/env bash

# sqlite string escaping
#
# no dependencies — pure string operation

ish_sqlite_escape() {
  local value="${1-}"
  printf '%s' "${value//\'/\'\'}"
}
