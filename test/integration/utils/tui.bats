#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish tui help shows usage" {
  run ./ish tui help
  assert_success
  assert_output --partial "usage: ish tui"
}

@test "ish tui info outputs message" {
  run ./ish tui info --message="test info"
  assert_success
  assert_output --partial "test info"
}

@test "ish tui warn outputs message" {
  run ./ish tui warn --message="test warning"
  assert_success
  assert_output --partial "test warning"
}

@test "ish tui error outputs message and exits" {
  run ./ish tui error --message="test error"
  assert_failure
  assert_output --partial "test error"
}

@test "ish tui info requires --message=" {
  run ./ish tui info
  assert_failure
  assert_output --partial "--message= required"
}

@test "ish tui info rejects unknown options" {
  run ./ish tui info --badopt="value"
  assert_failure
  assert_output --partial "unknown option"
}
