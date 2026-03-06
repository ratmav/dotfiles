#!/usr/bin/env bash

# sqlite error reporting
#
# dependencies: ish_stream_stderr, ISH_COLOR_RED, ISH_COLOR_CLEAR
# these functions are available because sqlite.sh sources dependencies before this module

ish_sqlite_error() {
  ish_stream_stderr "${ISH_COLOR_RED}ish_sqlite: ${1}${ISH_COLOR_CLEAR}"
  exit 1
}
