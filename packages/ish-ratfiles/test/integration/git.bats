#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "ish git help shows usage" {
  run ./ish ratfiles git help
  assert_success
  assert_output --partial "usage: ish ratfiles git"
}

@test "ish git clean help shows usage" {
  run ./ish ratfiles git clean help
  assert_success
  assert_output --partial "usage: ish ratfiles git clean"
}

@test "ish git clean with no args shows help" {
  run ./ish ratfiles git clean
  assert_success
  assert_output --partial "usage: ish ratfiles git clean"
}
