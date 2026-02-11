#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish ratfiles bootstrap macos help shows usage" {
  run ./ish ratfiles bootstrap macos help
  assert_success
  assert_output --partial "usage: ish ratfiles bootstrap macos"
}

@test "ish ratfiles bootstrap macos homebrew help shows usage" {
  run ./ish ratfiles bootstrap macos homebrew help
  assert_success
  assert_output --partial "usage: ish ratfiles bootstrap macos homebrew"
  refute_output --partial "--message="
}

@test "ish ratfiles bootstrap macos homebrew with no args shows clean help" {
  run ./ish ratfiles bootstrap macos homebrew
  assert_success
  assert_output --partial "usage: ish ratfiles bootstrap macos homebrew"
  refute_output --partial "--message="
  refute_output --partial "required"
}
