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

@test "ish_sqlite_query_one returns single row" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"
  sqlite3 "$db" "INSERT INTO items (name) VALUES ('foo');"

  run ish_sqlite_query_one --db="$db" --sql="SELECT name FROM items;"
  assert_success
  assert_output "foo"
}

@test "ish_sqlite_query_one returns pipe-separated columns" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT, status TEXT);"
  sqlite3 "$db" "INSERT INTO items (name, status) VALUES ('foo', 'open');"

  run ish_sqlite_query_one --db="$db" --sql="SELECT name, status FROM items;"
  assert_success
  assert_output "foo|open"
}

@test "ish_sqlite_query_one fails on zero rows" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"

  run ish_sqlite_query_one --db="$db" --sql="SELECT name FROM items;"
  assert_failure
  assert_output --partial "query_one: no rows returned"
}

@test "ish_sqlite_query_one fails on multiple rows" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"
  sqlite3 "$db" "INSERT INTO items (name) VALUES ('foo');"
  sqlite3 "$db" "INSERT INTO items (name) VALUES ('bar');"

  run ish_sqlite_query_one --db="$db" --sql="SELECT name FROM items;"
  assert_failure
  assert_output --partial "query_one: expected 1 row, got 2"
}

@test "ish_sqlite_query_one requires --db=" {
  run ish_sqlite_query_one --sql="SELECT 1;"
  assert_failure
  assert_output --partial "query_one: --db= required"
}

@test "ish_sqlite_query_one requires --sql=" {
  run ish_sqlite_query_one --db="/tmp/test.db"
  assert_failure
  assert_output --partial "query_one: --sql= required"
}

@test "ish_sqlite_query_one rejects unknown options" {
  run ish_sqlite_query_one --foo=bar
  assert_failure
  assert_output --partial "query_one: unknown option"
}
