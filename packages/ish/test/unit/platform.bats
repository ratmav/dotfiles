#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup

  source ${ISH_PACKAGES_DIR}/ish/source/platform.sh
}

# Baseline check: deliberately tests consistent system state
@test "platform_os outputs valid operating system" {
  run platform_os
  assert_success
  assert_output --regexp "^(macos|kali)$"
}

# Baseline check: deliberately tests consistent system state
@test "platform_arch outputs valid architecture" {
  run platform_arch
  assert_success
  assert_output --regexp "^(amd64|arm64)$"
}
