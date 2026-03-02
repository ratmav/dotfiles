#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish tui template help shows usage" {
  run ./ish tui template
  assert_success
  assert_output --partial "usage: ish tui template"
}

@test "ish tui template file outputs file contents" {
  run ./ish tui template file --path=${ISH_ROOT}/core/test/fixtures/tui/test-file.txt
  assert_success
  assert_output --partial "line one"
  assert_output --partial "line two"
  assert_output --partial "line three"
}

@test "ish tui template file preserves line order" {
  run ./ish tui template file --path=${ISH_ROOT}/core/test/fixtures/tui/test-file.txt
  assert_success
  assert_line --index 0 "line one"
  assert_line --index 1 "line two"
  assert_line --index 2 "line three"
}

@test "ish tui template file requires --path flag" {
  run ./ish tui template file
  assert_failure
  assert_output --partial "--path required"
}

@test "ish tui template file fails on nonexistent file" {
  run ./ish tui template file --path=nonexistent.txt
  assert_failure
  assert_output --partial "template not found"
}

@test "ish tui template file fails on directory" {
  run ./ish tui template file --path=${ISH_ROOT}/core/test/fixtures
  assert_failure
  assert_output --partial "not a template file"
}

@test "ish tui template file rejects unknown options" {
  run ./ish tui template file --badopt="value"
  assert_failure
  assert_output --partial "unknown option"
}
