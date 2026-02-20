#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup

  load '../../test_helper/fixtures'

  source ${ISH_CORE}/source/tui.sh
  source ${ISH_CORE}/source/utils/exists.sh
}

teardown() {
  fixture_cleanup
}

@test "ish_utils_exists_file detects fixture file" {
  fixture_file myfile_test_file
  assert ish_utils_exists_file --file="$ISH_TEST_FIXTURES/myfile_test_file"
}

@test "ish_utils_exists_file rejects nonexistent files" {
  refute ish_utils_exists_file --file=/tmp/fake_file_xyz_does_not_exist
}

@test "ish_utils_exists_file rejects directories" {
  refute ish_utils_exists_file --file="$ISH_TEST_FIXTURES"
}

@test "ish_utils_exists_file requires --file=" {
  run ish_utils_exists_file
  assert_failure
  assert_output --partial "--file= required"
}

@test "ish_utils_exists_file rejects unknown options" {
  run ish_utils_exists_file --unknown="value"
  assert_failure
  assert_output --partial "unknown option"
}
