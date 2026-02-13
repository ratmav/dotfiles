#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "ish help shows usage" {
  run ./ish help
  assert_success
  assert_output --partial "usage: ish"
}

@test "ish test help shows usage" {
  run ./ish test help
  assert_success
  assert_output --partial "usage: ish test"
}

@test "ish lint help shows usage" {
  run ./ish lint help
  assert_success
  assert_output --partial "usage: ish lint"
}
