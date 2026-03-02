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
