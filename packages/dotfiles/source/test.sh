#!/usr/bin/env bash

dotfiles_test_all() {
  "${ISH_PACKAGES_DIR}/dotfiles/test/bats/bin/bats" --recursive "${ISH_PACKAGES_DIR}/dotfiles/test/unit/" "${ISH_PACKAGES_DIR}/dotfiles/test/integration/"
}

dotfiles_test_unit() {
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
    test_path="${ISH_PACKAGES_DIR}/dotfiles/test/unit/${route}.bats"
    if [[ ! -f "$test_path" ]]; then
      utils_tui_error --message="test not found: $test_path"
    fi
  else
    test_path="${ISH_PACKAGES_DIR}/dotfiles/test/unit/"
  fi

  "${ISH_PACKAGES_DIR}/dotfiles/test/bats/bin/bats" --recursive "$test_path"
}

dotfiles_test_integration() {
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
    test_path="${ISH_PACKAGES_DIR}/dotfiles/test/integration/${route}.bats"
    if [[ ! -f "$test_path" ]]; then
      utils_tui_error --message="test not found: $test_path"
    fi
  else
    test_path="${ISH_PACKAGES_DIR}/dotfiles/test/integration/"
  fi

  "${ISH_PACKAGES_DIR}/dotfiles/test/bats/bin/bats" --recursive "$test_path"
}

dotfiles_test_route() {
  case "${1-}" in
  all)
    shift
    dotfiles_test_all "$@"
    ;;
  unit)
    shift
    dotfiles_test_unit "$@"
    ;;
  integration)
    shift
    dotfiles_test_integration "$@"
    ;;
  "")
    utils_stream_multiline_stderr <<EOF
usage: ish dotfiles test [suite] [options]

suites:
  all          run all tests
  unit         run unit tests only
  integration  run integration tests only

options:
  --route=PATH    run specific test file (e.g., bootstrap/posix)
EOF
    ;;
  *)
    utils_tui_error --message="unknown test suite: ${1-}"
    return 1
    ;;
  esac
}
