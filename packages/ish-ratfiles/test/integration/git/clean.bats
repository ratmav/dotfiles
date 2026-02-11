#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish git clean help shows usage" {
  run ./ish ratfiles git clean
  assert_success
  assert_output --partial "usage: ish ratfiles git clean"
}
