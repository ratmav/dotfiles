#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "dotfiles package integration test scaffold" {
  # This is a placeholder test demonstrating the structure
  # Real integration tests will validate end-to-end dotfiles workflows
  run ./ish dotfiles help
  assert_success
  assert_output --partial "usage: ish dotfiles"
}
