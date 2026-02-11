#!/usr/bin/env bash

_common_setup() {
  # Get the directory where this file lives (test/test_helper)
  local test_helper_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  load "${test_helper_dir}/bats-support/load"
  load "${test_helper_dir}/bats-assert/load"
}
