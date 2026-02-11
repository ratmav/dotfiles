#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish test shows usage when no suite specified" {
  run ./ish test
  assert_success
  assert_output --partial "usage: ish test"
}
