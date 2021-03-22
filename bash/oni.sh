#!/usr/bin/env bash

export NPM_CONFIG_PREFIX=/root/npm-global

oni_build() {
  $NPM_CONFIG_PREFIX/bin/esy install
  $NPM_CONFIG_PREFIX/bin/esy bootstrap
  $NPM_CONFIG_PREFIX/bin/esy build

  msg "${OK} debian-oni-build: front end built."
}

oni_release() {
  $NPM_CONFIG_PREFIX/bin/esy '@release' install
  $NPM_CONFIG_PREFIX/bin/esy '@release' run -f --checkhealth
  $NPM_CONFIG_PREFIX/bin/esy '@release' create

  msg "${OK} debian-oni-build: release built."
}

oni_clone() {
  rm -rf oni2
  git clone https://github.com/ratmav/oni2
  msg "${OK}debian-oni-build: cloned source."
}

main_oni() {
  #clone

  #cd ./oni2

  #node install-node-deps.js
  #esy_build
  #esy_release
}
