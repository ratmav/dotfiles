#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup

  load '../../test_helper/fixtures'

  source ${ISH_CORE}/source/git.sh
}

teardown() {
  fixture_cleanup
}

@test "ish_git_push pushes to remote" {
  local remote="${ISH_TEST_FIXTURES}/remote.git"
  local repo="${ISH_TEST_FIXTURES}/repo"

  git init --bare --quiet "$remote"
  git clone --quiet "$remote" "$repo"
  echo "hello" > "$repo/test.txt"
  git -C "$repo" add test.txt
  git -C "$repo" commit --quiet -m "initial"

  run ish_git_push --dir="$repo"
  assert_success
}

@test "ish_git_push fails with no remote" {
  local repo="${ISH_TEST_FIXTURES}/repo"
  mkdir -p "$repo"
  git -C "$repo" init --quiet
  echo "hello" > "$repo/test.txt"
  git -C "$repo" add test.txt
  git -C "$repo" commit --quiet -m "initial"

  run ish_git_push --dir="$repo"
  assert_failure
  assert_output --partial "push failed"
}

@test "ish_git_push requires --dir=" {
  run ish_git_push
  assert_failure
  assert_output --partial "push: --dir= required"
}

@test "ish_git_push rejects unknown options" {
  run ish_git_push --foo=bar
  assert_failure
  assert_output --partial "push: unknown option"
}
