#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup

  load '../../test_helper/fixtures'

  source ${ISH_EXTENSIONS}/source/sqlite3.sh
}

teardown() {
  fixture_cleanup
}

@test "ish_sqlite3_build_params_stdin outputs parameter set lines" {
  run ish_sqlite3_build_params_stdin "hello" "world"
  assert_success
  assert_line -n 0 '.parameter set ?1 "hello"'
  assert_line -n 1 '.parameter set ?2 "world"'
}

@test "ish_sqlite3_build_params_stdin escapes backslashes" {
  run ish_sqlite3_build_params_stdin 'back\slash'
  assert_success
  assert_output '.parameter set ?1 "back\\slash"'
}

@test "ish_sqlite3_build_params_stdin escapes double quotes" {
  run ish_sqlite3_build_params_stdin 'has "quotes"'
  assert_success
  assert_output '.parameter set ?1 "has \"quotes\""'
}

@test "ish_sqlite3_build_params_stdin handles empty value" {
  run ish_sqlite3_build_params_stdin ""
  assert_success
  assert_output '.parameter set ?1 ""'
}

@test "ish_sqlite3_build_params_stdin outputs nothing with no args" {
  run ish_sqlite3_build_params_stdin
  assert_success
  assert_output ""
}
