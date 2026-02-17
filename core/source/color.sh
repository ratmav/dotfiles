#!/usr/bin/env bash

# Foundation layer. No dependencies — this is the very bottom.
# Detects terminal capability and sets raw color codes.

ish_color_init() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    ISH_COLOR_RED=$'\033[0;31m'
    ISH_COLOR_GREEN=$'\033[0;32m'
    ISH_COLOR_YELLOW=$'\033[0;33m'
    ISH_COLOR_CLEAR=$'\033[0m'
  else
    ISH_COLOR_RED=''
    ISH_COLOR_GREEN=''
    ISH_COLOR_YELLOW=''
    ISH_COLOR_CLEAR=''
  fi
}
