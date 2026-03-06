#!/usr/bin/env bash

ish_test_all() {
  "${ISH_ROOT}/core/test/bats/bin/bats" --recursive \
    "${ISH_ROOT}/core/test/unit/" \
    "${ISH_ROOT}/core/test/integration/" \
    "${ISH_ROOT}/extensions/test/unit/"
}

ish_test_unit() {
  local route=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --route=*)
        route="${1#*=}"
        shift
        ;;
      *)
        ish_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  local test_path
  if [[ -n "$route" ]]; then
    test_path=$(_test_find_route "unit" "$route") \
      || ish_tui_error --message="test not found: ${route}"
  else
    test_path="${ISH_ROOT}/core/test/unit/"
  fi

  "${ISH_ROOT}/core/test/bats/bin/bats" --recursive "$test_path"
}

ish_test_integration() {
  local route=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --route=*)
        route="${1#*=}"
        shift
        ;;
      *)
        ish_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  local test_path
  if [[ -n "$route" ]]; then
    test_path=$(_test_find_route "integration" "$route") \
      || ish_tui_error --message="test not found: ${route}"
  else
    test_path="${ISH_ROOT}/core/test/integration/"
  fi

  "${ISH_ROOT}/core/test/bats/bin/bats" --recursive "$test_path"
}

ish_test_help() {
  ish_stream_multiline_stderr <<EOF
usage: ish test [suite] [options]

suites:
  all          run all tests
  unit         run unit tests only
  integration  run integration tests only

options:
  --route=PATH    run specific test file (e.g., tui/template)
EOF
}

ish_test_route() {
  case "${1-}" in
  all)
    shift
    ish_test_all "$@"
    ;;
  unit)
    shift
    ish_test_unit "$@"
    ;;
  integration)
    shift
    ish_test_integration "$@"
    ;;
  help|"")
    ish_test_help
    ;;
  *)
    ish_tui_error --message="unknown test suite: ${1-}"
    return 1
    ;;
  esac
}

# Private functions

_test_find_route() {
  local type="$1"
  local route="$2"
  local dirs=("${ISH_ROOT}/core/test/${type}" "${ISH_ROOT}/extensions/test/${type}")

  for dir in "${dirs[@]}"; do
    [[ -f "${dir}/${route}.bats" ]] && echo "${dir}/${route}.bats" && return 0
    [[ -d "${dir}/${route}" ]] && echo "${dir}/${route}" && return 0
  done

  return 1
}
