#!/usr/bin/env bash

main_vv() {
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

vv_build() {
  cd ./vv
  yarn
  yarn build:electron
  rm -rf ./vv
  msg "${OK}vv_build: build done."
}

vv_clone() {
  git clone https://github.com/ratmav/vv.git ./vv > /dev/null 2>&1
  msg "${OK}vv_clone: cloned source."
}
