#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup

  load '../test_helper/fixtures'

  source ${ISH_CORE}/source/sqlite.sh
}

teardown() {
  fixture_cleanup
}

@test "ish_sqlite_require succeeds when sqlite3 exists" {
  fixture_executable sqlite3
  run ish_sqlite_require
  assert_success
}

@test "ish_sqlite_require fails when sqlite3 missing" {
  # Ensure no fixture sqlite3 exists
  rm -f "$ISH_TEST_FIXTURES/sqlite3"

  # Remove any real sqlite3 from PATH
  local clean_path=""
  local dir
  while IFS= read -r -d: dir; do
    [[ "$dir" == "$ISH_TEST_FIXTURES" ]] && continue
    type -P sqlite3 &>/dev/null && clean_path="${clean_path:+$clean_path:}$dir" && continue
    clean_path="${clean_path:+$clean_path:}$dir"
  done <<< "$PATH:"

  # Use PATH with only dirs that don't contain sqlite3
  local original_path="$PATH"
  export PATH=""
  for dir in $(echo "$original_path" | tr ':' '\n'); do
    if [[ ! -x "$dir/sqlite3" ]]; then
      PATH="${PATH:+$PATH:}$dir"
    fi
  done

  run ish_sqlite_require
  assert_failure
  assert_output --partial "sqlite3 not found"

  export PATH="$original_path"
}

# --- ish_sqlite_exec ---

@test "ish_sqlite_exec creates table" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  run ish_sqlite_exec --db="$db" --sql="CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"
  assert_success

  # Verify table exists
  run sqlite3 "$db" ".tables"
  assert_output --partial "items"
}

@test "ish_sqlite_exec inserts data" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT);"
  run ish_sqlite_exec --db="$db" --sql="INSERT INTO items (name) VALUES ('foo');"
  assert_success

  run sqlite3 "$db" "SELECT name FROM items;"
  assert_output "foo"
}

@test "ish_sqlite_exec requires --db=" {
  run ish_sqlite_exec --sql="SELECT 1;"
  assert_failure
  assert_output --partial "exec: --db= required"
}

@test "ish_sqlite_exec requires --sql=" {
  run ish_sqlite_exec --db="/tmp/test.db"
  assert_failure
  assert_output --partial "exec: --sql= required"
}

@test "ish_sqlite_exec rejects unknown options" {
  run ish_sqlite_exec --foo=bar
  assert_failure
  assert_output --partial "exec: unknown option"
}

@test "ish_sqlite_exec fails on bad sql" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  run ish_sqlite_exec --db="$db" --sql="NOT VALID SQL;"
  assert_failure
  assert_output --partial "exec failed"
}

@test "ish_sqlite_exec enforces foreign keys" {
  local db="${ISH_TEST_FIXTURES}/test.db"
  mkdir -p "$ISH_TEST_FIXTURES"

  sqlite3 "$db" "CREATE TABLE parents (id INTEGER PRIMARY KEY);"
  sqlite3 "$db" "CREATE TABLE children (id INTEGER PRIMARY KEY, parent_id INTEGER REFERENCES parents(id));"

  run ish_sqlite_exec --db="$db" --sql="INSERT INTO children (parent_id) VALUES (999);"
  assert_failure
}
