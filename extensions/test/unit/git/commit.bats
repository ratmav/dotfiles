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

@test "ish_git_commit commits staged changes" {
  local repo="${ISH_TEST_FIXTURES}/repo"
  mkdir -p "$repo"
  git -C "$repo" init --quiet
  echo "hello" > "$repo/test.txt"
  git -C "$repo" add test.txt

  run ish_git_commit --dir="$repo" --message="test commit"
  assert_success

  run git -C "$repo" log --oneline
  assert_output --partial "test commit"
}

@test "ish_git_commit fails with nothing staged" {
  local repo="${ISH_TEST_FIXTURES}/repo"
  mkdir -p "$repo"
  git -C "$repo" init --quiet

  run ish_git_commit --dir="$repo" --message="empty"
  assert_failure
  assert_output --partial "commit failed"
}

@test "ish_git_commit requires --dir=" {
  run ish_git_commit --message="test"
  assert_failure
  assert_output --partial "commit: --dir= required"
}

@test "ish_git_commit requires --message=" {
  run ish_git_commit --dir="/tmp"
  assert_failure
  assert_output --partial "commit: --message= required"
}

@test "ish_git_commit rejects unknown options" {
  run ish_git_commit --foo=bar
  assert_failure
  assert_output --partial "commit: unknown option"
}
