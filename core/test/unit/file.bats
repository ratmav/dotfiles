#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup

  TEST_TMPDIR=$(mktemp -d)
}

teardown() {
  rm -rf "$TEST_TMPDIR"
}

# ish_file_read

@test "ish_file_read reads file contents to stdout" {
  echo "hello world" > "$TEST_TMPDIR/test.txt"
  run bash -c "
    source ${ISH_CORE}/source/file.sh
    ish_file_read --path='$TEST_TMPDIR/test.txt'
  "
  assert_success
  assert_output "hello world"
}

@test "ish_file_read reads multi-line file" {
  printf '%s\n' "line one" "line two" "line three" > "$TEST_TMPDIR/multi.txt"
  run bash -c "
    source ${ISH_CORE}/source/file.sh
    ish_file_read --path='$TEST_TMPDIR/multi.txt'
  "
  assert_success
  assert_line --index 0 "line one"
  assert_line --index 1 "line two"
  assert_line --index 2 "line three"
}

@test "ish_file_read fails on missing file" {
  run bash -c "source ${ISH_CORE}/source/file.sh; ish_file_read --path='$TEST_TMPDIR/nope.txt' 2>&1"
  assert_failure
  assert_output --partial "file not found"
}

@test "ish_file_read requires --path=" {
  run bash -c "source ${ISH_CORE}/source/file.sh; ish_file_read 2>&1"
  assert_failure
  assert_output --partial "--path= required"
}

@test "ish_file_read rejects unknown options" {
  run bash -c "source ${ISH_CORE}/source/file.sh; ish_file_read --unknown=x 2>&1"
  assert_failure
  assert_output --partial "unknown option"
}

# ish_file_write

@test "ish_file_write writes stdin to file" {
  run bash -c "
    source ${ISH_CORE}/source/file.sh
    echo 'test data' | ish_file_write --path='$TEST_TMPDIR/output.txt'
    cat '$TEST_TMPDIR/output.txt'
  "
  assert_success
  assert_output "test data"
}

@test "ish_file_write overwrites existing file" {
  echo "old content" > "$TEST_TMPDIR/overwrite.txt"
  run bash -c "
    source ${ISH_CORE}/source/file.sh
    echo 'new content' | ish_file_write --path='$TEST_TMPDIR/overwrite.txt'
    cat '$TEST_TMPDIR/overwrite.txt'
  "
  assert_success
  assert_output "new content"
}

@test "ish_file_write uses atomic temp+mv pattern" {
  run bash -c "
    source ${ISH_CORE}/source/file.sh
    echo 'atomic test' | ish_file_write --path='$TEST_TMPDIR/atomic.txt'
    # verify no leftover temp files
    ls '$TEST_TMPDIR'/.ish_file_write.* 2>/dev/null && echo 'temp leaked' || echo 'clean'
  "
  assert_success
  assert_output --partial "clean"
}

@test "ish_file_write requires --path=" {
  run bash -c "source ${ISH_CORE}/source/file.sh; echo 'x' | ish_file_write 2>&1"
  assert_failure
  assert_output --partial "--path= required"
}

@test "ish_file_write rejects unknown options" {
  run bash -c "source ${ISH_CORE}/source/file.sh; echo 'x' | ish_file_write --unknown=x 2>&1"
  assert_failure
  assert_output --partial "unknown option"
}

# ish_file_append

@test "ish_file_append appends stdin to existing file" {
  echo "first" > "$TEST_TMPDIR/append.txt"
  run bash -c "
    source ${ISH_CORE}/source/file.sh
    echo 'second' | ish_file_append --path='$TEST_TMPDIR/append.txt'
    cat '$TEST_TMPDIR/append.txt'
  "
  assert_success
  assert_line --index 0 "first"
  assert_line --index 1 "second"
}

@test "ish_file_append creates file if not exists" {
  run bash -c "
    source ${ISH_CORE}/source/file.sh
    echo 'new' | ish_file_append --path='$TEST_TMPDIR/new_append.txt'
    cat '$TEST_TMPDIR/new_append.txt'
  "
  assert_success
  assert_output "new"
}

@test "ish_file_append requires --path=" {
  run bash -c "source ${ISH_CORE}/source/file.sh; echo 'x' | ish_file_append 2>&1"
  assert_failure
  assert_output --partial "--path= required"
}

@test "ish_file_append rejects unknown options" {
  run bash -c "source ${ISH_CORE}/source/file.sh; echo 'x' | ish_file_append --unknown=x 2>&1"
  assert_failure
  assert_output --partial "unknown option"
}

# ish_file_exists

@test "ish_file_exists returns 0 for existing file" {
  touch "$TEST_TMPDIR/exists.txt"
  run bash -c "
    source ${ISH_CORE}/source/file.sh
    ish_file_exists --path='$TEST_TMPDIR/exists.txt'
  "
  assert_success
}

@test "ish_file_exists returns 1 for missing file" {
  run bash -c "
    source ${ISH_CORE}/source/file.sh
    ish_file_exists --path='$TEST_TMPDIR/nope.txt'
  "
  assert_failure
}

@test "ish_file_exists returns 1 for directory" {
  mkdir -p "$TEST_TMPDIR/adir"
  run bash -c "
    source ${ISH_CORE}/source/file.sh
    ish_file_exists --path='$TEST_TMPDIR/adir'
  "
  assert_failure
}

@test "ish_file_exists requires --path=" {
  run bash -c "source ${ISH_CORE}/source/file.sh; ish_file_exists 2>&1"
  assert_failure
  assert_output --partial "--path= required"
}

@test "ish_file_exists rejects unknown options" {
  run bash -c "source ${ISH_CORE}/source/file.sh; ish_file_exists --unknown=x 2>&1"
  assert_failure
  assert_output --partial "unknown option"
}

# ish_file_require

@test "ish_file_require succeeds on existing file" {
  touch "$TEST_TMPDIR/required.txt"
  run bash -c "
    source ${ISH_CORE}/source/file.sh
    ish_file_require --path='$TEST_TMPDIR/required.txt'
  "
  assert_success
}

@test "ish_file_require fails with custom message on missing file" {
  run bash -c "source ${ISH_CORE}/source/file.sh; ish_file_require --path='$TEST_TMPDIR/nope.txt' --message='config missing' 2>&1"
  assert_failure
  assert_output --partial "config missing"
}

@test "ish_file_require fails with default message on missing file" {
  run bash -c "source ${ISH_CORE}/source/file.sh; ish_file_require --path='$TEST_TMPDIR/nope.txt' 2>&1"
  assert_failure
  assert_output --partial "required file not found"
}

@test "ish_file_require requires --path=" {
  run bash -c "source ${ISH_CORE}/source/file.sh; ish_file_require 2>&1"
  assert_failure
  assert_output --partial "--path= required"
}

@test "ish_file_require rejects unknown options" {
  run bash -c "source ${ISH_CORE}/source/file.sh; ish_file_require --unknown=x 2>&1"
  assert_failure
  assert_output --partial "unknown option"
}

# ish_file_bind

@test "ish_file_bind chains operations with success" {
  run bash -c '
    source ${ISH_CORE}/source/file.sh
    _prefix() { printf "%s\n" "file:$1"; }
    printf "%s\n" "a.txt" "b.txt" | ish_file_bind _prefix
  '
  assert_success
  assert_line --index 0 "file:a.txt"
  assert_line --index 1 "file:b.txt"
}

@test "ish_file_bind short-circuits on failure" {
  run bash -c '
    source ${ISH_CORE}/source/file.sh
    _fail_on_bad() {
      if [[ "$1" == "bad" ]]; then return 1; fi
      printf "%s\n" "ok:$1"
    }
    printf "%s\n" "good" "bad" "good" | ish_file_bind _fail_on_bad
  '
  assert_failure
  assert_output "ok:good"
}

@test "ish_file_bind requires function argument" {
  run bash -c 'source ${ISH_CORE}/source/file.sh; echo "x" | ish_file_bind 2>&1'
  assert_failure
  assert_output --partial "ish_file:"
}

# monad laws

@test "ish_file_bind left identity" {
  run bash -c '
    source ${ISH_CORE}/source/file.sh
    _prefix() { printf "%s\n" "pre:$1"; }
    result=$(echo "test" | ish_file_bind _prefix)
    expected=$(_prefix "test")
    [[ "$result" == "$expected" ]]
  '
  assert_success
}

@test "ish_file_bind right identity" {
  run bash -c '
    source ${ISH_CORE}/source/file.sh
    _return() { printf "%s\n" "$1"; }
    result=$(echo "test" | ish_file_bind _return)
    [[ "$result" == "test" ]]
  '
  assert_success
}

@test "ish_file_bind associativity" {
  run bash -c '
    source ${ISH_CORE}/source/file.sh
    _double() { printf "%s\n" "${1}${1}"; }
    _upper() { printf "%s\n" "${1^^}"; }
    left=$(echo "ab" | ish_file_bind _double | ish_file_bind _upper)
    _composed() { printf "%s\n" "$1" | ish_file_bind _double | ish_file_bind _upper; }
    right=$(echo "ab" | ish_file_bind _composed)
    [[ "$left" == "$right" ]]
  '
  assert_success
}
