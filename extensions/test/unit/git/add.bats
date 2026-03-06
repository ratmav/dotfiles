#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup

  load '../../test_helper/fixtures'

  source ${ISH_EXTENSIONS}/source/git.sh
}

teardown() {
  fixture_cleanup
}

@test "ish_git_add stages a file" {
  local repo="${ISH_TEST_FIXTURES}/repo"
  mkdir -p "$repo"
  git -C "$repo" init --quiet
  echo "hello" > "$repo/test.txt"

  run ish_git_add --dir="$repo" --path="test.txt"
  assert_success

  run git -C "$repo" diff --cached --name-only
  assert_output "test.txt"
}

@test "ish_git_add fails on nonexistent file" {
  local repo="${ISH_TEST_FIXTURES}/repo"
  mkdir -p "$repo"
  git -C "$repo" init --quiet

  run ish_git_add --dir="$repo" --path="ghost.txt"
  assert_failure
  assert_output --partial "add failed"
}

@test "ish_git_add requires --dir=" {
  run ish_git_add --path="test.txt"
  assert_failure
  assert_output --partial "add: --dir= required"
}

@test "ish_git_add requires --path=" {
  run ish_git_add --dir="/tmp"
  assert_failure
  assert_output --partial "add: --path= required"
}

@test "ish_git_add rejects unknown options" {
  run ish_git_add --foo=bar
  assert_failure
  assert_output --partial "add: unknown option"
}
