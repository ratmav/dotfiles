#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

setup() {
  load '../test_helper/common-setup'
  _common_setup

  source "${ISH_CORE}/source/file.sh"

  TEST_TMPDIR=$(mktemp -d)
}

teardown() {
  rm -rf "$TEST_TMPDIR"
}

# ish_file_read

@test "ish_file_read reads file contents to stdout" {
  echo "hello world" > "$TEST_TMPDIR/test.txt"
  run ish_file_read --path="$TEST_TMPDIR/test.txt"
  assert_success
  assert_output "hello world"
}

@test "ish_file_read reads multi-line file" {
  printf '%s\n' "line one" "line two" "line three" > "$TEST_TMPDIR/multi.txt"
  run ish_file_read --path="$TEST_TMPDIR/multi.txt"
  assert_success
  assert_line --index 0 "line one"
  assert_line --index 1 "line two"
  assert_line --index 2 "line three"
}

@test "ish_file_read fails on missing file" {
  run ish_file_read --path="$TEST_TMPDIR/nope.txt"
  assert_failure
  assert_output --partial "file not found"
}

@test "ish_file_read requires --path=" {
  run ish_file_read
  assert_failure
  assert_output --partial "--path= required"
}

@test "ish_file_read rejects unknown options" {
  run ish_file_read --unknown=x
  assert_failure
  assert_output --partial "unknown option"
}

# ish_file_write

@test "ish_file_write writes stdin to file" {
  echo 'test data' | ish_file_write --path="$TEST_TMPDIR/output.txt"
  run cat "$TEST_TMPDIR/output.txt"
  assert_success
  assert_output "test data"
}

@test "ish_file_write overwrites existing file" {
  echo "old content" > "$TEST_TMPDIR/overwrite.txt"
  echo 'new content' | ish_file_write --path="$TEST_TMPDIR/overwrite.txt"
  run cat "$TEST_TMPDIR/overwrite.txt"
  assert_success
  assert_output "new content"
}

@test "ish_file_write uses atomic temp+mv pattern" {
  echo 'atomic test' | ish_file_write --path="$TEST_TMPDIR/atomic.txt"
  # verify no leftover temp files
  run bash -c "ls '$TEST_TMPDIR'/.ish_file_write.* 2>/dev/null && echo 'temp leaked' || echo 'clean'"
  assert_success
  assert_output --partial "clean"
}

@test "ish_file_write requires --path=" {
  run ish_file_write < <(echo 'x')
  assert_failure
  assert_output --partial "--path= required"
}

@test "ish_file_write rejects unknown options" {
  run ish_file_write --unknown=x < <(echo 'x')
  assert_failure
  assert_output --partial "unknown option"
}

# ish_file_append

@test "ish_file_append appends stdin to existing file" {
  echo "first" > "$TEST_TMPDIR/append.txt"
  echo 'second' | ish_file_append --path="$TEST_TMPDIR/append.txt"
  run cat "$TEST_TMPDIR/append.txt"
  assert_success
  assert_line --index 0 "first"
  assert_line --index 1 "second"
}

@test "ish_file_append creates file if not exists" {
  echo 'new' | ish_file_append --path="$TEST_TMPDIR/new_append.txt"
  run cat "$TEST_TMPDIR/new_append.txt"
  assert_success
  assert_output "new"
}

@test "ish_file_append requires --path=" {
  run ish_file_append < <(echo 'x')
  assert_failure
  assert_output --partial "--path= required"
}

@test "ish_file_append rejects unknown options" {
  run ish_file_append --unknown=x < <(echo 'x')
  assert_failure
  assert_output --partial "unknown option"
}

# ish_file_exists

@test "ish_file_exists returns 0 for existing file" {
  touch "$TEST_TMPDIR/exists.txt"
  run ish_file_exists --path="$TEST_TMPDIR/exists.txt"
  assert_success
}

@test "ish_file_exists returns 1 for missing file" {
  run ish_file_exists --path="$TEST_TMPDIR/nope.txt"
  assert_failure
}

@test "ish_file_exists returns 1 for directory" {
  mkdir -p "$TEST_TMPDIR/adir"
  run ish_file_exists --path="$TEST_TMPDIR/adir"
  assert_failure
}

@test "ish_file_exists requires --path=" {
  run ish_file_exists
  assert_failure
  assert_output --partial "--path= required"
}

@test "ish_file_exists rejects unknown options" {
  run ish_file_exists --unknown=x
  assert_failure
  assert_output --partial "unknown option"
}

# ish_file_require

@test "ish_file_require succeeds on existing file" {
  touch "$TEST_TMPDIR/required.txt"
  run ish_file_require --path="$TEST_TMPDIR/required.txt"
  assert_success
}

@test "ish_file_require fails with custom message on missing file" {
  run ish_file_require --path="$TEST_TMPDIR/nope.txt" --message="config missing"
  assert_failure
  assert_output --partial "config missing"
}

@test "ish_file_require fails with default message on missing file" {
  run ish_file_require --path="$TEST_TMPDIR/nope.txt"
  assert_failure
  assert_output --partial "required file not found"
}

@test "ish_file_require requires --path=" {
  run ish_file_require
  assert_failure
  assert_output --partial "--path= required"
}

@test "ish_file_require rejects unknown options" {
  run ish_file_require --unknown=x
  assert_failure
  assert_output --partial "unknown option"
}
