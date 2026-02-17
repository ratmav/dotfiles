#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup

  TEST_TMPDIR=$(mktemp -d)
}

teardown() {
  rm -rf "$TEST_TMPDIR"
}

@test "ish_file_descriptor_open and read lifecycle" {
  echo "hello world" > "$TEST_TMPDIR/test.txt"
  run bash -c "
    source ${ISH_CORE}/source/file_descriptor.sh
    ish_file_descriptor_open --path='$TEST_TMPDIR/test.txt' --fd=5 --mode=read
    ish_file_descriptor_read --fd=5
    ish_file_descriptor_close --fd=5
  "
  assert_success
  assert_output "hello world"
}

@test "ish_file_descriptor_open write and verify" {
  run bash -c "
    source ${ISH_CORE}/source/file_descriptor.sh
    ish_file_descriptor_open --path='$TEST_TMPDIR/output.txt' --fd=5 --mode=write
    echo 'test data' | ish_file_descriptor_write --fd=5
    ish_file_descriptor_close --fd=5
    cat '$TEST_TMPDIR/output.txt'
  "
  assert_success
  assert_output "test data"
}

@test "ish_file_descriptor_close closes file descriptor" {
  run bash -c "
    source ${ISH_CORE}/source/file_descriptor.sh
    ish_file_descriptor_open --path='$TEST_TMPDIR/close.txt' --fd=5 --mode=write
    ish_file_descriptor_close --fd=5
    { true >&5; } 2>/dev/null && echo 'still open' || echo 'closed'
  "
  assert_success
  assert_output "closed"
}

@test "ish_file_descriptor_duplicate copies fd" {
  echo "duplicate test" > "$TEST_TMPDIR/dup.txt"
  run bash -c "
    source ${ISH_CORE}/source/file_descriptor.sh
    ish_file_descriptor_open --path='$TEST_TMPDIR/dup.txt' --fd=5 --mode=read
    ish_file_descriptor_duplicate --source=5 --target=6
    ish_file_descriptor_read --fd=6
    ish_file_descriptor_close --fd=5
    ish_file_descriptor_close --fd=6
  "
  assert_success
  assert_output "duplicate test"
}

@test "ish_file_descriptor_require succeeds on open fd" {
  run bash -c "
    source ${ISH_CORE}/source/file_descriptor.sh
    ish_file_descriptor_require --fd=1
  "
  assert_success
}

@test "ish_file_descriptor_require fails on closed fd" {
  run bash -c "source ${ISH_CORE}/source/file_descriptor.sh; ish_file_descriptor_require --fd=99 2>&1"
  assert_failure
  assert_output --partial "fd 99 is not open"
}

@test "ish_file_descriptor_open requires --fd=" {
  run bash -c "source ${ISH_CORE}/source/file_descriptor.sh; ish_file_descriptor_open --path=/tmp/test --mode=read 2>&1"
  assert_failure
  assert_output --partial "--fd= required"
}

@test "ish_file_descriptor_open requires --path=" {
  run bash -c "source ${ISH_CORE}/source/file_descriptor.sh; ish_file_descriptor_open --fd=5 --mode=read 2>&1"
  assert_failure
  assert_output --partial "--path= required"
}

@test "ish_file_descriptor_open requires --mode=" {
  run bash -c "source ${ISH_CORE}/source/file_descriptor.sh; ish_file_descriptor_open --path=/tmp/test --fd=5 2>&1"
  assert_failure
  assert_output --partial "--mode= required"
}

@test "ish_file_descriptor_open rejects unknown options" {
  run bash -c "source ${ISH_CORE}/source/file_descriptor.sh; ish_file_descriptor_open --unknown=x 2>&1"
  assert_failure
  assert_output --partial "unknown option"
}

@test "ish_file_descriptor_open rejects invalid mode" {
  run bash -c "source ${ISH_CORE}/source/file_descriptor.sh; ish_file_descriptor_open --path=/tmp/test --fd=5 --mode=invalid 2>&1"
  assert_failure
  assert_output --partial "unknown mode"
}
