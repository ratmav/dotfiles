#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "ish ratfiles git help shows usage" {
  run ./ish ratfiles git help
  assert_success
  assert_output --partial "usage: ish ratfiles git"
}
