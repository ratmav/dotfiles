#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "ish platform help shows usage" {
  run ./ish platform help
  assert_success
  assert_output --partial "usage: ish platform"
}

@test "ish platform with no args shows help" {
  run ./ish platform
  assert_success
  assert_output --partial "usage: ish platform"
}

@test "ish platform with invalid command shows error" {
  run ./ish platform invalid_command
  assert_failure
  assert_output --partial "unknown platform command"
}
