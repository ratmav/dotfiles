#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish dotfiles bootstrap posix help shows usage" {
  run ./ish dotfiles bootstrap posix help
  assert_success
  assert_output --partial "usage: ish dotfiles bootstrap posix"
}
