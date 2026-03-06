#!/usr/bin/env bash

# sqlite3 binary validation
#
# dependencies: ish_exists_executable, ish_sqlite3_error
# these functions are available because sqlite3.sh sources dependencies before this module

ish_sqlite3_require() {
  ish_exists_executable --executable=sqlite3 \
    || ish_sqlite3_error "sqlite3 not found. install sqlite3."
}
