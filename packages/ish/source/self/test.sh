#!/usr/bin/env bash

self_test_all() {
  "${ISH_PACKAGES_DIR}/../test/bats/bin/bats" --recursive "${ISH_PACKAGES_DIR}/../test/unit/" "${ISH_PACKAGES_DIR}/../test/integration/"
}

self_test_unit() {
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
    test_path="${ISH_PACKAGES_DIR}/../test/unit/${route}.bats"
    if [[ ! -f "$test_path" ]]; then
      utils_tui_error --message="test not found: $test_path"
    fi
  else
    test_path="${ISH_PACKAGES_DIR}/../test/unit/"
  fi

  "${ISH_PACKAGES_DIR}/../test/bats/bin/bats" --recursive "$test_path"
}

self_test_integration() {
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
    test_path="${ISH_PACKAGES_DIR}/../test/integration/${route}.bats"
    if [[ ! -f "$test_path" ]]; then
      utils_tui_error --message="test not found: $test_path"
    fi
  else
    test_path="${ISH_PACKAGES_DIR}/../test/integration/"
  fi

  "${ISH_PACKAGES_DIR}/../test/bats/bin/bats" --recursive "$test_path"
}
