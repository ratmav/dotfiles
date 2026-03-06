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

@test "ish_sqlite3_dump outputs INSERT statements" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"
  sqlite3 "$db" "INSERT INTO items (name) VALUES ('foo');"

  run ish_sqlite3_dump --db="$db"
  assert_success
  assert_output --partial "INSERT INTO"
  assert_output --partial "'foo'"
}

@test "ish_sqlite3_dump excludes schema" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"
  sqlite3 "$db" "INSERT INTO items (name) VALUES ('foo');"

  run ish_sqlite3_dump --db="$db"
  assert_success
  refute_output --partial "CREATE TABLE"
}

@test "ish_sqlite3_dump filters by table" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"
  sqlite3 "$db" "CREATE TABLE other (id INTEGER PRIMARY KEY, val TEXT);"
  sqlite3 "$db" "INSERT INTO items (name) VALUES ('foo');"
  sqlite3 "$db" "INSERT INTO other (val) VALUES ('bar');"

  run ish_sqlite3_dump --db="$db" --tables="items"
  assert_success
  assert_output --partial "'foo'"
  refute_output --partial "'bar'"
}

@test "ish_sqlite3_dump fails on empty database" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"

  run ish_sqlite3_dump --db="$db"
  assert_failure
  assert_output --partial "dump: no data to export"
}

@test "ish_sqlite3_dump fails on missing database" {
  run ish_sqlite3_dump --db="/tmp/ish_fixtures/nonexistent.db"
  assert_failure
  assert_output --partial "dump: database not found"
}

@test "ish_sqlite3_dump requires --db=" {
  run ish_sqlite3_dump
  assert_failure
  assert_output --partial "dump: --db= required"
}

@test "ish_sqlite3_dump rejects unknown options" {
  run ish_sqlite3_dump --foo=bar
  assert_failure
  assert_output --partial "dump: unknown option"
}
