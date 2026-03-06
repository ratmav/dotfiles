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

@test "ish_sqlite3_escape passes through clean string" {
  run ish_sqlite3_escape "hello"
  assert_success
  assert_output "hello"
}

@test "ish_sqlite3_escape doubles single quotes" {
  run ish_sqlite3_escape "it's"
  assert_success
  assert_output "it''s"
}

@test "ish_sqlite3_escape handles multiple single quotes" {
  run ish_sqlite3_escape "it's a dog's life"
  assert_success
  assert_output "it''s a dog''s life"
}

@test "ish_sqlite3_escape handles empty string" {
  run ish_sqlite3_escape ""
  assert_success
  assert_output ""
}

@test "ish_sqlite3_escape handles string of only quotes" {
  run ish_sqlite3_escape "'''"
  assert_success
  assert_output "''''''"
}
