#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup

  source ${ISH_CORE}/source/git.sh
}

@test "ish_git_error exits with failure" {
  run ish_git_error "something broke"
  assert_failure
}

@test "ish_git_error includes ish_git prefix in output" {
  run ish_git_error "something broke"
  assert_output --partial "ish_git: something broke"
}
