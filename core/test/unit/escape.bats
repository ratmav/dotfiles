#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup

  load '../test_helper/fixtures'

  source ${ISH_CORE}/source/escape.sh
}

teardown() {
  fixture_cleanup
}

_test_double_value() { printf '%s%s' "$1" "$1"; }

_test_identity() { printf '%s' "$1"; }

@test "ish_escape applies strategy function" {
  run ish_escape _test_double_value "abc"
  assert_success
  assert_output "abcabc"
}

@test "ish_escape passes through clean value with identity strategy" {
  run ish_escape _test_identity "hello"
  assert_success
  assert_output "hello"
}

@test "ish_escape handles empty value" {
  run ish_escape _test_identity ""
  assert_success
  assert_output ""
}

@test "ish_escape requires strategy function" {
  run ish_escape
  assert_failure
  assert_output --partial "strategy function required"
}
