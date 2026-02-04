#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish bootstrap posix help shows usage" {
  run ./ish bootstrap posix help
  assert_success
  assert_output --partial "usage: ish bootstrap posix"
}
