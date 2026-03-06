#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup

  load '../../test_helper/fixtures'

  source ${ISH_EXTENSIONS}/source/sqlite.sh
}

teardown() {
  fixture_cleanup
}

@test "ish_sqlite_query returns rows" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"
  sqlite3 "$db" "INSERT INTO items (name) VALUES ('foo');"
  sqlite3 "$db" "INSERT INTO items (name) VALUES ('bar');"

  run ish_sqlite_query --db="$db" --sql="SELECT name FROM items ORDER BY name;"
  assert_success
  assert_line -n 0 "bar"
  assert_line -n 1 "foo"
}

@test "ish_sqlite_query uses pipe separator for multiple columns" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT, status TEXT);"
  sqlite3 "$db" "INSERT INTO items (name, status) VALUES ('foo', 'open');"

  run ish_sqlite_query --db="$db" --sql="SELECT name, status FROM items;"
  assert_success
  assert_output "foo|open"
}

@test "ish_sqlite_query returns empty output for no rows" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"

  run ish_sqlite_query --db="$db" --sql="SELECT name FROM items;"
  assert_success
  assert_output ""
}

@test "ish_sqlite_query requires --db=" {
  run ish_sqlite_query --sql="SELECT 1;"
  assert_failure
  assert_output --partial "query: --db= required"
}

@test "ish_sqlite_query requires --sql=" {
  run ish_sqlite_query --db="/tmp/test.db"
  assert_failure
  assert_output --partial "query: --sql= required"
}

@test "ish_sqlite_query rejects unknown options" {
  run ish_sqlite_query --foo=bar
  assert_failure
  assert_output --partial "query: unknown option"
}

@test "ish_sqlite_query fails on bad sql" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  run ish_sqlite_query --db="$db" --sql="SELECT FROM nowhere;"
  assert_failure
  assert_output --partial "query failed"
}

@test "ish_sqlite_query enforces foreign keys" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE parents (id INTEGER PRIMARY KEY);"
  sqlite3 "$db" "CREATE TABLE children (id INTEGER PRIMARY KEY, parent_id INTEGER REFERENCES parents(id));"

  run ish_sqlite_query --db="$db" --sql="INSERT INTO children (parent_id) VALUES (999); SELECT * FROM children;"
  assert_failure
}
