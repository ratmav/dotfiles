#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "ish utils help shows usage" {
  run ./ish utils help
  assert_success
  assert_output --partial "usage: ish utils"
}

@test "ish utils with no args shows help" {
  run ./ish utils
  assert_success
  assert_output --partial "usage: ish utils"
}

@test "ish utils with invalid command shows error" {
  run ./ish utils invalid_command
  assert_failure
  assert_output --partial "unknown utils command"
}
