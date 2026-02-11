#!/usr/bin/env bats

# unit tests for tui template module
# tests ish_utils_tui_template and ish_utils_tui_template_file functions

setup() {
  load '../../../test_helper/common-setup'
  _common_setup

  source ${ISH_CORE}/source/utils/tui.sh
  source ${ISH_CORE}/source/utils/exists.sh
  source ${ISH_CORE}/source/utils/tui/template.sh
}

# ish_utils_tui_template - string templating with {{variable}} substitution

@test "ish_utils_tui_template substitutes single variable" {
  run ish_utils_tui_template "" "hello {{name}}" name world
  assert_success
  assert_output "hello world"
}

@test "ish_utils_tui_template substitutes multiple variables" {
  run ish_utils_tui_template "" "{{greeting}} {{name}}" greeting hello name world
  assert_success
  assert_output "hello world"
}

@test "ish_utils_tui_template with level prefix" {
  run ish_utils_tui_template "PREFIX: " "{{msg}}" msg test
  assert_success
  assert_output "PREFIX: test"
}

# ish_utils_tui_template_file - output file contents to stdout

@test "ish_utils_tui_template_file outputs file contents" {
  run ish_utils_tui_template_file --path=${ISH_ROOT}/core/test/fixtures/tui/test-file.txt
  assert_success
  assert_output --partial "line one"
  assert_output --partial "line two"
  assert_output --partial "line three"
}

@test "ish_utils_tui_template_file preserves line order" {
  run ish_utils_tui_template_file --path=${ISH_ROOT}/core/test/fixtures/tui/test-file.txt
  assert_success
  assert_line --index 0 "line one"
  assert_line --index 1 "line two"
  assert_line --index 2 "line three"
}

@test "ish_utils_tui_template_file requires --path flag" {
  run ish_utils_tui_template_file
  assert_failure
  assert_output --partial "--path required"
}

@test "ish_utils_tui_template_file fails on nonexistent file" {
  run ish_utils_tui_template_file --path=nonexistent.txt
  assert_failure
  assert_output --partial "template not found"
}

@test "ish_utils_tui_template_file fails on directory" {
  run ish_utils_tui_template_file --path=${ISH_ROOT}/core/test/fixtures
  assert_failure
  assert_output --partial "not a template file"
}
