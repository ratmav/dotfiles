#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup

  source ${ISH_CORE}/platform.sh
}

# Baseline check: deliberately tests consistent system state
@test "ish_platform_os outputs valid operating system" {
  run ish_platform_os
  assert_success
  assert_output --regexp "^(macos|kali)$"
}

# Baseline check: deliberately tests consistent system state
@test "ish_platform_arch outputs valid architecture" {
  run ish_platform_arch
  assert_success
  assert_output --regexp "^(amd64|arm64)$"
}
