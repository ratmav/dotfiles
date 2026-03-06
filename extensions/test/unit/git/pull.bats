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

@test "ish_git_pull pulls from remote" {
  local remote="${ISH_TEST_FIXTURES}/remote.git"
  local repo="${ISH_TEST_FIXTURES}/repo"
  local other="${ISH_TEST_FIXTURES}/other"

  git init --bare --quiet "$remote"
  git clone --quiet "$remote" "$repo"
  git clone --quiet "$remote" "$other"

  echo "hello" > "$other/test.txt"
  git -C "$other" add test.txt
  git -C "$other" commit --quiet -m "from other"
  git -C "$other" push --quiet

  run ish_git_pull --dir="$repo"
  assert_success
}

@test "ish_git_pull fails with no remote" {
  local repo="${ISH_TEST_FIXTURES}/repo"
  mkdir -p "$repo"
  git -C "$repo" init --quiet

  run ish_git_pull --dir="$repo"
  assert_failure
  assert_output --partial "pull failed"
}

@test "ish_git_pull requires --dir=" {
  run ish_git_pull
  assert_failure
  assert_output --partial "pull: --dir= required"
}

@test "ish_git_pull rejects unknown options" {
  run ish_git_pull --foo=bar
  assert_failure
  assert_output --partial "pull: unknown option"
}
