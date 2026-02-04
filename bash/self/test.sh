#!/usr/bin/env bash

self_test_all() {
  "${script_dir}/test/bats/bin/bats" --recursive "${script_dir}/test/unit/" "${script_dir}/test/integration/"
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
    test_path="${script_dir}/test/unit/${route}.bats"
    if [[ ! -f "$test_path" ]]; then
      utils_tui_error --message="test not found: $test_path"
    fi
  else
    test_path="${script_dir}/test/unit/"
  fi

  "${script_dir}/test/bats/bin/bats" --recursive "$test_path"
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
    test_path="${script_dir}/test/integration/${route}.bats"
    if [[ ! -f "$test_path" ]]; then
      utils_tui_error --message="test not found: $test_path"
    fi
  else
    test_path="${script_dir}/test/integration/"
  fi

  "${script_dir}/test/bats/bin/bats" --recursive "$test_path"
}
