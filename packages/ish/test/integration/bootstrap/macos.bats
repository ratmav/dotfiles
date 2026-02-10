#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish dotfiles bootstrap macos help shows usage" {
  run ./ish dotfiles bootstrap macos help
  assert_success
  assert_output --partial "usage: ish dotfiles bootstrap macos"
}

@test "ish dotfiles bootstrap macos homebrew help shows usage" {
  run ./ish dotfiles bootstrap macos homebrew help
  assert_success
  assert_output --partial "usage: ish dotfiles bootstrap macos homebrew"
  refute_output --partial "--message="
}

@test "ish dotfiles bootstrap macos homebrew with no args shows clean help" {
  run ./ish dotfiles bootstrap macos homebrew
  assert_success
  assert_output --partial "usage: ish dotfiles bootstrap macos homebrew"
  refute_output --partial "--message="
  refute_output --partial "required"
}
