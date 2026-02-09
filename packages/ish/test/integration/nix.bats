#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "ish nix help shows usage" {
  run ./ish dotfiles nix help
  assert_success
  assert_output --partial "usage: ish dotfiles nix"
}

@test "ish nix with no args shows help" {
  run ./ish dotfiles nix
  assert_success
  assert_output --partial "usage: ish dotfiles nix"
}

@test "ish nix with invalid command shows error" {
  run ./ish dotfiles nix invalid_command
  assert_failure
  assert_output --partial "unknown nix command"
}

# Note: nix semantic requires network/user input,
# so we only test CLI routing and help text here
