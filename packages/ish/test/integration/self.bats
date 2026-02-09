#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "ish test help shows usage" {
  run ./ish test help
  assert_success
  assert_output --partial "usage: ish test"
}
