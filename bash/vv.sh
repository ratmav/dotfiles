#!/usr/bin/env bash

main_vv() {
  if ! [ -x "$(command -v yarn)" ]; then
    die "yarn not installed. try calling posix_node."
  else
    rm -rf ./vv
    vv_clone
  fi
}

vv_clone() {
    git clone https://github.com/vv-vim/vv.git ./vv > /dev/null 2>&1
    msg "${OK}vv_clone: cloned source."
}
