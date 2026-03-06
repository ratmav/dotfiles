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

@test "ish_git_require succeeds in a git repo" {
  local repo="${ISH_TEST_FIXTURES}/repo"
  mkdir -p "$repo"
  git -C "$repo" init --quiet

  run ish_git_require --dir="$repo"
  assert_success
}

@test "ish_git_require fails outside a git repo" {
  local notrepo="${ISH_TEST_FIXTURES}/notrepo"
  mkdir -p "$notrepo"

  run ish_git_require --dir="$notrepo"
  assert_failure
  assert_output --partial "not a git repository"
}

@test "ish_git_require requires --dir=" {
  run ish_git_require
  assert_failure
  assert_output --partial "require: --dir= required"
}

@test "ish_git_require rejects unknown options" {
  run ish_git_require --foo=bar
  assert_failure
  assert_output --partial "require: unknown option"
}
