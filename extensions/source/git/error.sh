#!/usr/bin/env bash

# git error reporting
#
# dependencies: ish_stream_stderr, ISH_COLOR_RED, ISH_COLOR_CLEAR
# these functions are available because git.sh sources dependencies before this module

ish_git_error() {
  ish_stream_stderr "${ISH_COLOR_RED}ish_git: ${1}${ISH_COLOR_CLEAR}"
  exit 1
}
