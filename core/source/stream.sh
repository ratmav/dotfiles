#!/usr/bin/env bash

# Primitive layer. Built on file_descriptor.
# FP operations on data flowing through pipes: map, bind, filter, fold.
# Also provides stdout/stderr output — the error output mechanism everything upstream uses.

_stream_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${_stream_dir}/file_descriptor.sh"

ish_stream_bind() {
  local func="${1-}"

  [[ -z "$func" ]] && _stream_error "--func required as first argument"

  local line
  while IFS= read -r line; do
    "$func" "$line" || return $?
  done
}

ish_stream_filter() {
  local predicate="${1-}"

  [[ -z "$predicate" ]] && _stream_error "--predicate required as first argument"

  local line
  while IFS= read -r line; do
    if "$predicate" "$line"; then
      printf '%s\n' "$line"
    fi
  done
}

ish_stream_fold() {
  local func="${1-}"
  local accumulator="${2-}"

  [[ -z "$func" ]] && _stream_error "--func required as first argument"

  local line
  while IFS= read -r line; do
    accumulator=$("$func" "$accumulator" "$line")
  done
  printf '%s\n' "$accumulator"
}

ish_stream_map() {
  local func="${1-}"

  [[ -z "$func" ]] && _stream_error "--func required as first argument"

  local line
  while IFS= read -r line; do
    "$func" "$line"
  done
}

ish_stream_stderr() {
  printf '%s\n' "$*" >&2
}

ish_stream_stdout() {
  printf '%s\n' "$*"
}

# Private functions

_stream_error() {
  printf '%s\n' "${ISH_COLOR_RED}ish_stream: ${1}${ISH_COLOR_CLEAR}" >&2
  exit 1
}
