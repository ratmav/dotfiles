#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "ish ratfiles nix help shows usage" {
  run ./ish ratfiles nix help
  assert_success
  assert_output --partial "usage: ish ratfiles nix"
}

@test "ish ratfiles nix with no args shows help" {
  run ./ish ratfiles nix
  assert_success
  assert_output --partial "usage: ish ratfiles nix"
}

@test "ish ratfiles nix with invalid command shows error" {
  run ./ish ratfiles nix invalid_command
  assert_failure
  assert_output --partial "unknown nix command"
}

# Note: nix semantic requires network/user input,
# so we only test CLI routing and help text here
