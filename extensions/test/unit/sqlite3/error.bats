#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup

  source ${ISH_EXTENSIONS}/source/sqlite.sh
}

@test "ish_sqlite_error exits with failure" {
  run ish_sqlite_error "something broke"
  assert_failure
}

@test "ish_sqlite_error includes ish_sqlite prefix in output" {
  run ish_sqlite_error "something broke"
  assert_output --partial "ish_sqlite: something broke"
}
