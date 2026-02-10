#!/usr/bin/env bash

# Stream output functions - handle stdout/stderr separation
# See docs/conventions.md for stream separation pattern

ish_utils_stream_stdout() {
  printf '%s\n' "$*"
}

ish_utils_stream_stderr() {
  printf '%s\n' "$*" >&2
}

ish_utils_stream_multiline_stdout() {
  local lines
  local i
  mapfile -t lines
  for i in "${!lines[@]}"; do
    printf '%s\n' "${lines[$i]}"
  done
}

ish_utils_stream_multiline_stderr() {
  local lines
  local i
  mapfile -t lines
  for i in "${!lines[@]}"; do
    printf '%s\n' "${lines[$i]}" >&2
  done
}
