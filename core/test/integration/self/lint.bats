#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish lint shows usage when no target specified" {
  run ./ish lint
  assert_success
  assert_output --partial "usage: ish lint"
}
