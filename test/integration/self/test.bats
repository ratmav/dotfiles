#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish self test shows usage when no suite specified" {
  run ./ish self test
  assert_success
  assert_output --partial "usage: ish self test"
}
