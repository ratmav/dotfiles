#!/usr/bin/env bats

setup() {
  load '../../../test_helper/common-setup'
  _common_setup

  load '../../../test_helper/fixtures'
}

teardown() {
  fixture_cleanup
}

@test "ish dotfiles bootstrap posix nix is idempotent" {
  fixture_executable nix

  run ./ish dotfiles bootstrap posix nix
  assert_success
  assert_output --partial "already installed"
}
