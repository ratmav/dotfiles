#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup

  source ${ISH_CORE}/source/tui.sh
}

# ish_tui_error - CRITICAL: must exit with code 1 (fail-fast behavior)
# Note: `run` executes commands in a subshell, so exit won't kill the test suite

@test "ish_tui_error exits with code 1" {
  run ish_tui_error --message="fatal error"
  assert_failure
  assert_equal "$status" 1
}

@test "ish_tui_error outputs error message" {
  run ish_tui_error --message="error message"
  assert_failure
  assert_output --partial "error message"
}

@test "ish_tui_error requires --message=" {
  run ish_tui_error
  assert_failure
  assert_output --partial "--message= required"
}

@test "ish_tui_error rejects unknown options" {
  run ish_tui_error --unknown="value"
  assert_failure
  assert_output --partial "unknown option"
}

# ish_tui_info - must continue execution (not exit)

@test "ish_tui_info outputs info message" {
  run ish_tui_info --message="info message"
  assert_success
  assert_output --partial "info message"
}

@test "ish_tui_info requires --message=" {
  run ish_tui_info
  assert_failure
  assert_output --partial "--message= required"
}

@test "ish_tui_info rejects unknown options" {
  run ish_tui_info --unknown="value"
  assert_failure
  assert_output --partial "unknown option"
}

# ish_tui_warn - must continue execution (not exit)

@test "ish_tui_warn outputs warning message" {
  run ish_tui_warn --message="warning message"
  assert_success
  assert_output --partial "warning message"
}

@test "ish_tui_warn requires --message=" {
  run ish_tui_warn
  assert_failure
  assert_output --partial "--message= required"
}

@test "ish_tui_warn rejects unknown options" {
  run ish_tui_warn --unknown="value"
  assert_failure
  assert_output --partial "unknown option"
}

# ish_tui_help

@test "ish_tui_help outputs usage" {
  run ish_tui_help
  assert_success
  assert_output --partial "usage: ish tui"
}
