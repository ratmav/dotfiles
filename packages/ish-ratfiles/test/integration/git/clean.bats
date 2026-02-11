#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish ratfiles git clean help shows usage" {
  run ./ish ratfiles git clean help
  assert_success
  assert_output --partial "usage: ish ratfiles git clean"
}

@test "ish ratfiles git clean with no args shows help" {
  run ./ish ratfiles git clean
  assert_success
  assert_output --partial "usage: ish ratfiles git clean"
}
