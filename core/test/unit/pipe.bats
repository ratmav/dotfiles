#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

setup() {
  load '../test_helper/common-setup'
  _common_setup

  source "${ISH_CORE}/source/pipe.sh"

  TEST_TMPDIR=$(mktemp -d)
}

teardown() {
  rm -rf "$TEST_TMPDIR"
}

# ish_pipe_connect

@test "ish_pipe_connect pipes stdout of first to stdin of second" {
  _produce() { printf '%s\n' "hello"; }
  _upcase() { tr 'a-z' 'A-Z'; }
  run ish_pipe_connect _produce _upcase
  assert_success
  assert_output "HELLO"
}

@test "ish_pipe_connect handles multi-line output" {
  _produce() { printf '%s\n' "alpha" "bravo"; }
  _upcase() { tr 'a-z' 'A-Z'; }
  run ish_pipe_connect _produce _upcase
  assert_success
  assert_line --index 0 "ALPHA"
  assert_line --index 1 "BRAVO"
}

@test "ish_pipe_connect requires first command" {
  run ish_pipe_connect
  assert_failure
  assert_output --partial "ish_pipe:"
}

@test "ish_pipe_connect requires second command" {
  _noop() { :; }
  run ish_pipe_connect _noop
  assert_failure
  assert_output --partial "ish_pipe:"
}

# ish_pipe_compose

@test "ish_pipe_compose chains three commands" {
  _produce() { printf '%s\n' "hello"; }
  _upcase() { tr 'a-z' 'A-Z'; }
  _add_prefix() { sed 's/^/PREFIX_/'; }
  run ish_pipe_compose _produce _upcase _add_prefix
  assert_success
  assert_output "PREFIX_HELLO"
}

@test "ish_pipe_compose with two commands works like connect" {
  _produce() { printf '%s\n' "hello"; }
  _upcase() { tr 'a-z' 'A-Z'; }
  run ish_pipe_compose _produce _upcase
  assert_success
  assert_output "HELLO"
}

@test "ish_pipe_compose handles more than five stages" {
  _produce() { printf '%s\n' "hello"; }
  _a() { sed 's/^/a_/'; }
  _b() { sed 's/^/b_/'; }
  _c() { sed 's/^/c_/'; }
  _d() { sed 's/^/d_/'; }
  _e() { sed 's/^/e_/'; }
  _f() { sed 's/^/f_/'; }
  run ish_pipe_compose _produce _a _b _c _d _e _f
  assert_success
  assert_output "f_e_d_c_b_a_hello"
}

@test "ish_pipe_compose requires at least two commands" {
  _noop() { :; }
  run ish_pipe_compose _noop
  assert_failure
  assert_output --partial "ish_pipe:"
}

@test "ish_pipe_compose with no commands fails" {
  run ish_pipe_compose
  assert_failure
  assert_output --partial "ish_pipe:"
}

# ish_pipe_tee

@test "ish_pipe_tee writes stdin to file and passes through to stdout" {
  printf '%s\n' "hello" | ish_pipe_tee "$TEST_TMPDIR/tee_dest.txt" > "$TEST_TMPDIR/tee_stdout.txt"

  run cat "$TEST_TMPDIR/tee_dest.txt"
  assert_success
  assert_output "hello"

  run cat "$TEST_TMPDIR/tee_stdout.txt"
  assert_success
  assert_output "hello"
}

@test "ish_pipe_tee writes to multiple destinations" {
  printf '%s\n' "hello" | ish_pipe_tee "$TEST_TMPDIR/dest1.txt" "$TEST_TMPDIR/dest2.txt" > /dev/null

  run cat "$TEST_TMPDIR/dest1.txt"
  assert_success
  assert_output "hello"

  run cat "$TEST_TMPDIR/dest2.txt"
  assert_success
  assert_output "hello"
}

@test "ish_pipe_tee requires at least one destination" {
  run ish_pipe_tee
  assert_failure
  assert_output --partial "ish_pipe:"
}

# ish_pipe_status

@test "ish_pipe_status outputs exit codes after successful pipeline" {
  run bash -c "
    source '${ISH_CORE}/source/pipe.sh'
    _ok() { printf 'ok'; }
    _also_ok() { cat; }
    ish_pipe_connect _ok _also_ok > /dev/null
    ish_pipe_status
  "
  assert_success
  assert_line --index 0 "0"
  assert_line --index 1 "0"
}

@test "ish_pipe_status captures failing stage exit code" {
  run bash -c "
    source '${ISH_CORE}/source/pipe.sh'
    _produce() { printf 'data'; }
    _fail() { cat > /dev/null; return 42; }
    ish_pipe_connect _produce _fail > /dev/null 2>/dev/null || true
    ish_pipe_status
  "
  assert_success
  assert_line --index 0 "0"
  assert_line --index 1 "42"
}

@test "ish_pipe_status captures failing middle stage in compose" {
  run bash -c "
    source '${ISH_CORE}/source/pipe.sh'
    _produce() { printf 'data\n'; }
    _fail() { cat > /dev/null; return 7; }
    _consume() { cat; }
    ish_pipe_compose _produce _fail _consume > /dev/null 2>/dev/null || true
    ish_pipe_status
  "
  assert_success
  assert_line --index 0 "0"
  assert_line --index 1 "7"
  assert_line --index 2 "0"
}

@test "ish_pipe_status outputs nothing before any pipeline" {
  run bash -c "
    source '${ISH_CORE}/source/pipe.sh'
    ish_pipe_status
  "
  assert_success
  refute_output
}

# ish_pipe_require_success

@test "ish_pipe_require_success passes when all stages succeed" {
  run bash -c "
    source '${ISH_CORE}/source/pipe.sh'
    _ok() { printf 'ok'; }
    _also_ok() { cat; }
    ish_pipe_connect _ok _also_ok > /dev/null
    ish_pipe_require_success
  "
  assert_success
}

@test "ish_pipe_require_success fails when a stage fails" {
  run bash -c "
    source '${ISH_CORE}/source/pipe.sh'
    _produce() { printf 'data'; }
    _fail() { cat > /dev/null; return 1; }
    ish_pipe_connect _produce _fail > /dev/null 2>/dev/null || true
    ish_pipe_require_success 2>&1
  "
  assert_failure
  assert_output --partial "stage 2 failed"
}

@test "ish_pipe_require_success reports exact exit code" {
  run bash -c "
    source '${ISH_CORE}/source/pipe.sh'
    _produce() { printf 'data'; }
    _fail() { cat > /dev/null; return 42; }
    ish_pipe_connect _produce _fail > /dev/null 2>/dev/null || true
    ish_pipe_require_success 2>&1
  "
  assert_failure
  assert_output --partial "exit code 42"
}

@test "ish_pipe_require_success passes with empty status" {
  run bash -c "
    source '${ISH_CORE}/source/pipe.sh'
    ish_pipe_require_success
  "
  assert_success
}
