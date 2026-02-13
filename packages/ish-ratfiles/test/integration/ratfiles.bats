#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "ish ratfiles help shows usage" {
  run ./ish ratfiles help
  assert_success
  assert_output --partial "usage: ish ratfiles"
}

@test "ish ratfiles with no args shows help" {
  run ./ish ratfiles
  assert_success
  assert_output --partial "usage: ish ratfiles"
}
