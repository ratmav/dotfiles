#!/usr/bin/env bash

ish_dotfiles_test_all() {
  "${ISH_PACKAGES_DIR}/ish-dotfiles/test/bats/bin/bats" --recursive "${ISH_PACKAGES_DIR}/ish-dotfiles/test/integration/"
}

ish_dotfiles_test_integration() {
  local route=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --route=*)
        route="${1#*=}"
        shift
        ;;
      *)
        ish_utils_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  local test_path
  if [[ -n "$route" ]]; then
    test_path="${ISH_PACKAGES_DIR}/ish-dotfiles/test/integration/${route}.bats"
    if [[ ! -f "$test_path" ]]; then
      ish_utils_tui_error --message="test not found: $test_path"
    fi
  else
    test_path="${ISH_PACKAGES_DIR}/ish-dotfiles/test/integration/"
  fi

  "${ISH_PACKAGES_DIR}/ish-dotfiles/test/bats/bin/bats" --recursive "$test_path"
}

ish_dotfiles_test_route() {
  case "${1-}" in
  all)
    shift
    ish_dotfiles_test_all "$@"
    ;;
  integration)
    shift
    ish_dotfiles_test_integration "$@"
    ;;
  "")
    ish_utils_stream_multiline_stderr <<EOF
usage: ish dotfiles test [suite] [options]

suites:
  all          run all tests (integration only)
  integration  run integration tests

options:
  --route=PATH    run specific test file (e.g., bootstrap/posix)
EOF
    ;;
  *)
    ish_utils_tui_error --message="unknown test suite: ${1-}"
    return 1
    ;;
  esac
}
