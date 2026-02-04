#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish self lint shows usage when no target specified" {
  run ./ish self lint
  assert_success
  assert_output --partial "usage: ish self lint"
}
