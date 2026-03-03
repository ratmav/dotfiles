#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup

  load '../../test_helper/fixtures'

  source ${ISH_CORE}/source/sqlite.sh
}

teardown() {
  fixture_cleanup
}

@test "ish_sqlite_load imports sql from stdin" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  run ish_sqlite_load --db="$db" <<< "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT); INSERT INTO items (name) VALUES ('foo');"
  assert_success

  run sqlite3 "$db" "SELECT name FROM items;"
  assert_output "foo"
}

@test "ish_sqlite_load round trips with dump" {
  local src="${ISH_TEST_FIXTURES}/src.db"
  local dst="${ISH_TEST_FIXTURES}/dst.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$src" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"
  sqlite3 "$src" "INSERT INTO items (name) VALUES ('foo');"
  sqlite3 "$src" "INSERT INTO items (name) VALUES ('bar');"

  # Create same schema in destination
  sqlite3 "$dst" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"

  # Dump from source, load into destination
  ish_sqlite_dump --db="$src" | ish_sqlite_load --db="$dst"

  run sqlite3 "$dst" "SELECT count(*) FROM items;"
  assert_output "2"
}

@test "ish_sqlite_load fails on bad sql" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  run ish_sqlite_load --db="$db" <<< "NOT VALID SQL AT ALL;"
  assert_failure
}

@test "ish_sqlite_load requires --db=" {
  run ish_sqlite_load <<< "SELECT 1;"
  assert_failure
  assert_output --partial "load: --db= required"
}

@test "ish_sqlite_load rejects unknown options" {
  run ish_sqlite_load --foo=bar <<< "SELECT 1;"
  assert_failure
  assert_output --partial "load: unknown option"
}
