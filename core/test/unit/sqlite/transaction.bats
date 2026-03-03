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

@test "ish_sqlite_transaction commits on success" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"

  run ish_sqlite_transaction --db="$db" <<< "INSERT INTO items (name) VALUES ('foo'); INSERT INTO items (name) VALUES ('bar');"
  assert_success

  run sqlite3 "$db" "SELECT count(*) FROM items;"
  assert_output "2"
}

@test "ish_sqlite_transaction rolls back on failure" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT NOT NULL);"

  run ish_sqlite_transaction --db="$db" <<< "INSERT INTO items (name) VALUES ('foo'); INSERT INTO items (name) VALUES (NULL);"
  assert_failure

  run sqlite3 "$db" "SELECT count(*) FROM items;"
  assert_output "0"
}

@test "ish_sqlite_transaction enforces foreign keys" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE parents (id INTEGER PRIMARY KEY);"
  sqlite3 "$db" "CREATE TABLE children (id INTEGER PRIMARY KEY, parent_id INTEGER REFERENCES parents(id));"

  run ish_sqlite_transaction --db="$db" <<< "INSERT INTO children (parent_id) VALUES (999);"
  assert_failure

  run sqlite3 "$db" "SELECT count(*) FROM children;"
  assert_output "0"
}

@test "ish_sqlite_transaction requires --db=" {
  run ish_sqlite_transaction <<< "SELECT 1;"
  assert_failure
  assert_output --partial "transaction: --db= required"
}

@test "ish_sqlite_transaction rejects unknown options" {
  run ish_sqlite_transaction --foo=bar <<< "SELECT 1;"
  assert_failure
  assert_output --partial "transaction: unknown option"
}
