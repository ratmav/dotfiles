#!/usr/bin/env bash

elementary_clean() {

}

main_elementary() {
  if [[ $(uname) == "Darwin" ]]; then
    if ! [ -x "$(command -v yarn)" ]; then
      die "main_vv: yarn not installed. try calling posix_node."
    else
      rm -rf ./vv
      vv_clone
      vv_build
    fi
  else
    die "main_vv: unsupported operating system."
  fi
}
