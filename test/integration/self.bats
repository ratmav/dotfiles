#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "ish self help shows usage" {
  run ./ish self help
  assert_success
  assert_output --partial "usage: ish self"
}
