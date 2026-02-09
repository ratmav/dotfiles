#!/usr/bin/env bash

ish_test_all() {
  "${ISH_PACKAGES_DIR}/ish/test/bats/bin/bats" --recursive "${ISH_PACKAGES_DIR}/ish/test/unit/" "${ISH_PACKAGES_DIR}/ish/test/integration/"
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
        utils_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  local test_path
  if [[ -n "$route" ]]; then
    test_path="${ISH_PACKAGES_DIR}/ish/test/unit/${route}.bats"
    if [[ ! -f "$test_path" ]]; then
      utils_tui_error --message="test not found: $test_path"
    fi
  else
    test_path="${ISH_PACKAGES_DIR}/ish/test/unit/"
  fi

  "${ISH_PACKAGES_DIR}/ish/test/bats/bin/bats" --recursive "$test_path"
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
        utils_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  local test_path
  if [[ -n "$route" ]]; then
    test_path="${ISH_PACKAGES_DIR}/ish/test/integration/${route}.bats"
    if [[ ! -f "$test_path" ]]; then
      utils_tui_error --message="test not found: $test_path"
    fi
  else
    test_path="${ISH_PACKAGES_DIR}/ish/test/integration/"
  fi

  "${ISH_PACKAGES_DIR}/ish/test/bats/bin/bats" --recursive "$test_path"
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
    utils_stream_multiline_stderr <<EOF
usage: ish test [suite] [options]

suites:
  all          run all tests
  unit         run unit tests only
  integration  run integration tests only

options:
  --route=PATH    run specific test file (e.g., tui/template)
EOF
    ;;
  *)
    utils_tui_error --message="unknown test suite: ${1-}"
    return 1
    ;;
  esac
}
