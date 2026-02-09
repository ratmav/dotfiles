#!/usr/bin/env bats

# bats 1.5.0+ required for run --keep-empty-lines flag
# bats will warn (BW02) if this check is missing
bats_require_minimum_version 1.5.0

setup() {
  load '../test_helper/common-setup'
  _common_setup

  source ${ISH_PACKAGES_DIR}/ish/source/utils.sh
}

# Stream separation tests

@test "utils_stream_stdout writes to stdout" {
  run bash -c 'source ${ISH_PACKAGES_DIR}/ish/source/utils.sh; utils_stream_stdout "test" >/tmp/stdout.txt 2>/tmp/stderr.txt; cat /tmp/stdout.txt'
  assert_output "test"

  # verify stderr is empty
  run cat /tmp/stderr.txt
  assert_output ""
}

@test "utils_stream_stderr writes to stderr" {
  run bash -c 'source ${ISH_PACKAGES_DIR}/ish/source/utils.sh; utils_stream_stderr "test" >/tmp/stdout.txt 2>/tmp/stderr.txt; cat /tmp/stderr.txt'
  assert_output "test"

  # verify stdout is empty
  run cat /tmp/stdout.txt
  assert_output ""
}

@test "utils_stream_stdout handles dash prefixed arguments" {
  run bash -c 'source ${ISH_PACKAGES_DIR}/ish/source/utils.sh; utils_stream_stdout "-n"'
  assert_output "-n"
}

@test "utils_stream_stderr handles dash prefixed arguments" {
  run bash -c 'source ${ISH_PACKAGES_DIR}/ish/source/utils.sh; utils_stream_stderr "-n" 2>&1'
  assert_output "-n"
}

# utils_stream_multiline_stdout - multi-line output to stdout

@test "utils_stream_multiline_stdout outputs multiple lines to stdout" {
  run bash -c 'source ${ISH_PACKAGES_DIR}/ish/source/utils.sh; utils_stream_multiline_stdout <<EOF
line one
line two
line three
EOF'
  assert_success
  assert_line --index 0 "line one"
  assert_line --index 1 "line two"
  assert_line --index 2 "line three"
}

@test "utils_stream_multiline_stdout preserves blank lines" {
  run --keep-empty-lines bash -c 'source ${ISH_PACKAGES_DIR}/ish/source/utils.sh; printf "%s\n%s\n%s\n" "first" "" "second" | utils_stream_multiline_stdout'
  assert_success
  assert_line --index 0 "first"
  assert_line --index 1 ""
  assert_line --index 2 "second"
}

# utils_stream_multiline_stderr - multi-line output to stderr

@test "utils_stream_multiline_stderr outputs multiple lines to stderr" {
  run bash -c 'source ${ISH_PACKAGES_DIR}/ish/source/utils.sh; utils_stream_multiline_stderr <<EOF
line one
line two
line three
EOF' 2>&1
  assert_success
  assert_line --index 0 "line one"
  assert_line --index 1 "line two"
  assert_line --index 2 "line three"
}

@test "utils_stream_multiline_stderr preserves blank lines" {
  run --keep-empty-lines bash -c 'source ${ISH_PACKAGES_DIR}/ish/source/utils.sh; printf "%s\n%s\n%s\n" "first" "" "second" | utils_stream_multiline_stderr 2>&1'
  assert_success
  assert_line --index 0 "first"
  assert_line --index 1 ""
  assert_line --index 2 "second"
}
