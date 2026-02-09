#!/usr/bin/env bats

# unit tests for tui template module
# tests utils_tui_template and utils_tui_template_file functions

setup() {
  load '../../../test_helper/common-setup'
  _common_setup

  source ${ISH_PACKAGES_DIR}/ish/source/utils/tui.sh
  source ${ISH_PACKAGES_DIR}/ish/source/utils/exists.sh
  source ${ISH_PACKAGES_DIR}/ish/source/utils/tui/template.sh
}

# utils_tui_template - string templating with {{variable}} substitution

@test "utils_tui_template substitutes single variable" {
  run utils_tui_template "" "hello {{name}}" name world
  assert_success
  assert_output "hello world"
}

@test "utils_tui_template substitutes multiple variables" {
  run utils_tui_template "" "{{greeting}} {{name}}" greeting hello name world
  assert_success
  assert_output "hello world"
}

@test "utils_tui_template with level prefix" {
  run utils_tui_template "PREFIX: " "{{msg}}" msg test
  assert_success
  assert_output "PREFIX: test"
}

# utils_tui_template_file - output file contents to stdout

@test "utils_tui_template_file outputs file contents" {
  run utils_tui_template_file --path=${ISH_PACKAGES_DIR}/ish/test/fixtures/tui/test-file.txt
  assert_success
  assert_output --partial "line one"
  assert_output --partial "line two"
  assert_output --partial "line three"
}

@test "utils_tui_template_file preserves line order" {
  run utils_tui_template_file --path=${ISH_PACKAGES_DIR}/ish/test/fixtures/tui/test-file.txt
  assert_success
  assert_line --index 0 "line one"
  assert_line --index 1 "line two"
  assert_line --index 2 "line three"
}

@test "utils_tui_template_file requires --path flag" {
  run utils_tui_template_file
  assert_failure
  assert_output --partial "--path required"
}

@test "utils_tui_template_file fails on nonexistent file" {
  run utils_tui_template_file --path=nonexistent.txt
  assert_failure
  assert_output --partial "template not found"
}

@test "utils_tui_template_file fails on directory" {
  run utils_tui_template_file --path=${ISH_PACKAGES_DIR}/ish/test/fixtures
  assert_failure
  assert_output --partial "not a template file"
}
