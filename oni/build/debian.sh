#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

export NPM_CONFIG_PREFIX=/root/npm-global

esy_build() {
  $NPM_CONFIG_PREFIX/bin/esy install
  $NPM_CONFIG_PREFIX/bin/esy bootstrap
  $NPM_CONFIG_PREFIX/bin/esy build

  msg "${OK} debian-oni-build: front end built."
}

esy_release() {
  $NPM_CONFIG_PREFIX/bin/esy '@release' install
  $NPM_CONFIG_PREFIX/bin/esy '@release' run -f --checkhealth
  $NPM_CONFIG_PREFIX/bin/esy '@release' create

  msg "${OK} debian-oni-build: release built."
}

# TODO: this needs a kernel, which means a full vm. vagrant it is.
fuse() {
  apt-get install -y fuse
  modprobe fuse
  groupadd fuse

  user="$(whoami)"
  usermod -a -G fuse $user
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
}

clone() {
  rm -rf oni2
  git clone https://github.com/ratmav/oni2
  msg "${OK}debian-oni-build: cloned source."
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "${ERROR}$msg"
  exit "$code"
}

msg() {
  # CLEAR restores colors.
  echo >&2 -e "${1-}${CLEAR}"
}

node() {
  curl -sL https://deb.nodesource.com/setup_15.x | bash -

  apt-get install -y nodejs

  rm -rf $NPM_CONFIG_PREFIX
  mkdir $NPM_CONFIG_PREFIX

  npm install -g node-gyp
  npm install -gf esy

  msg "${OK}debian-oni-build: installed node and dependencies."
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    ERROR='\033[0;31m' CLEAR='\033[0m' OK='\033[0;32m' WARN='\033[0;33m'
  else
    ERROR='' CLEAR='' OK='' WARN=''
  fi
}

# TODO: get this into a dockerfile for speed on iteration.
system_packages() {
  apt-get update
  apt-get upgrade -y

  PACKAGES=("apt-utils" "build-essential" "libtool" "gettext" "nasm" "libacl1-dev"
    "libncurses-dev" "libglu1-mesa-dev" "libxxf86vm-dev" "libxkbfile-dev"
    "git-core" "curl" "libpng-dev" "libbz2-dev" "m4" "xorg-dev"
    "libharfbuzz-dev" "libgtk-3-dev" "libfontconfig1-dev" "clang"
    "software-properties-common" "dialog" "wget")
  for package in "${PACKAGES[@]}"; do
    if dpkg -l | grep -w $package > /dev/null 2>&1; then
      msg "${WARN}debian-oni-build: $package already installed."
    else
      apt-get install -y $package
      msg "${OK}debian-oni-build: installed $package."
    fi
  done
}

# TODO: call this script from a dockerfile once it works (shoud run, build, copy binary
#       to the bin dir, and exit.
main() {
  setup_colors
  system_packages
  fuse

  node
  clone

  cd ./oni2
  node install-node-deps.js
  esy_build
  esy_release
}

main "$@"
