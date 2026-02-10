#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "dotfiles package unit test scaffold" {
  # This is a placeholder test demonstrating the structure
  # Real dotfiles tests will validate bootstrap, git, nix functionality
  run echo "hello from dotfiles unit tests"
  assert_success
  assert_output "hello from dotfiles unit tests"
}
