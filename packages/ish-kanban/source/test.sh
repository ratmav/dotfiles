#!/usr/bin/env bash

ish_kanban_test_all() {
  "${ISH_PACKAGES}/ish-kanban/test/bats/bin/bats" --recursive "${ISH_PACKAGES}/ish-kanban/test/unit/" "${ISH_PACKAGES}/ish-kanban/test/integration/"
}

ish_kanban_test_unit() {
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
    test_path="${ISH_PACKAGES}/ish-kanban/test/unit/${route}.bats"
    if [[ ! -f "$test_path" ]]; then
      ish_tui_error --message="test not found: $test_path"
    fi
  else
    test_path="${ISH_PACKAGES}/ish-kanban/test/unit/"
  fi

  "${ISH_PACKAGES}/ish-kanban/test/bats/bin/bats" --recursive "$test_path"
}

ish_kanban_test_integration() {
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
    test_path="${ISH_PACKAGES}/ish-kanban/test/integration/${route}.bats"
    if [[ ! -f "$test_path" ]]; then
      ish_tui_error --message="test not found: $test_path"
    fi
  else
    test_path="${ISH_PACKAGES}/ish-kanban/test/integration/"
  fi

  "${ISH_PACKAGES}/ish-kanban/test/bats/bin/bats" --recursive "$test_path"
}

ish_kanban_test_route() {
  case "${1-}" in
  all)
    shift
    ish_kanban_test_all "$@"
    ;;
  unit)
    shift
    ish_kanban_test_unit "$@"
    ;;
  integration)
    shift
    ish_kanban_test_integration "$@"
    ;;
  "")
    ish_stream_multiline_stderr <<EOF
usage: ish kanban test [suite] [options]

suites:
  all          run all tests
  unit         run unit tests only
  integration  run integration tests only

options:
  --route=PATH    run specific test file (e.g., kanban/board)
EOF
    ;;
  *)
    ish_tui_error --message="unknown test suite: ${1-}"
    return 1
    ;;
  esac
}
