#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "ish dotfiles bootstrap help shows usage" {
  run ./ish dotfiles bootstrap help
  assert_success
  assert_output --partial "usage: ish dotfiles bootstrap"
}
