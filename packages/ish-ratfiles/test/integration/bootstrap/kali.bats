#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish ratfiles bootstrap kali help shows usage" {
  run ./ish ratfiles bootstrap kali help
  assert_success
  assert_output --partial "usage: ish ratfiles bootstrap kali"
}
