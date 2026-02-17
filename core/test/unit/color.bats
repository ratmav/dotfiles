#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup

  source ${ISH_CORE}/source/color.sh
}

@test "ish_color_init succeeds" {
  run ish_color_init
  assert_success
}

@test "ish_color_init sets empty colors in non-terminal context" {
  ish_color_init
  assert_equal "$ISH_COLOR_RED" ""
  assert_equal "$ISH_COLOR_GREEN" ""
  assert_equal "$ISH_COLOR_YELLOW" ""
  assert_equal "$ISH_COLOR_CLEAR" ""
}

@test "ish_color_init sets empty colors when NO_COLOR is set" {
  export NO_COLOR=1
  ish_color_init
  assert_equal "$ISH_COLOR_RED" ""
  assert_equal "$ISH_COLOR_GREEN" ""
  assert_equal "$ISH_COLOR_YELLOW" ""
  assert_equal "$ISH_COLOR_CLEAR" ""
}
