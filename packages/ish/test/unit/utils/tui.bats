#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup

  source ${ISH_PACKAGES_DIR}/ish/source/utils/tui.sh
}

# utils_tui_error - CRITICAL: must exit with code 1 (fail-fast behavior)
# Note: `run` executes commands in a subshell, so exit won't kill the test suite

@test "utils_tui_error exits with code 1" {
  run utils_tui_error --message="fatal error"
  assert_failure
  assert_equal "$status" 1
}

@test "utils_tui_error outputs error message" {
  run utils_tui_error --message="error message"
  assert_failure
  assert_output --partial "error message"
}

@test "utils_tui_error requires --message=" {
  run utils_tui_error
  assert_failure
  assert_output --partial "--message= required"
}

@test "utils_tui_error rejects unknown options" {
  run utils_tui_error --unknown="value"
  assert_failure
  assert_output --partial "unknown option"
}

# utils_tui_info - must continue execution (not exit)

@test "utils_tui_info outputs info message" {
  run utils_tui_info --message="info message"
  assert_success
  assert_output --partial "info message"
}

@test "utils_tui_info requires --message=" {
  run utils_tui_info
  assert_failure
  assert_output --partial "--message= required"
}

@test "utils_tui_info rejects unknown options" {
  run utils_tui_info --unknown="value"
  assert_failure
  assert_output --partial "unknown option"
}

# utils_tui_warn - must continue execution (not exit)

@test "utils_tui_warn outputs warning message" {
  run utils_tui_warn --message="warning message"
  assert_success
  assert_output --partial "warning message"
}

@test "utils_tui_warn requires --message=" {
  run utils_tui_warn
  assert_failure
  assert_output --partial "--message= required"
}

@test "utils_tui_warn rejects unknown options" {
  run utils_tui_warn --unknown="value"
  assert_failure
  assert_output --partial "unknown option"
}

# utils_tui_help

@test "utils_tui_help outputs usage" {
  run utils_tui_help
  assert_success
  assert_output --partial "usage: ish tui"
}
