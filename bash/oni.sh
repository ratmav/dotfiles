#!/usr/bin/env bash

export NPM_CONFIG_PREFIX=/root/npm-global

main_oni() {
  if [[ $(uname) == "Darwin" ]]; then
    oni_macos
  elif cat /etc/issue | grep "Debian" > /dev/null 2>&1; then
    oni_debian
  else
    die "unsupported operating system."
  fi
}

oni_build() {
  $NPM_CONFIG_PREFIX/bin/esy install
  $NPM_CONFIG_PREFIX/bin/esy bootstrap
  $NPM_CONFIG_PREFIX/bin/esy build

  msg "${OK} debian-oni-build: front end built."
}

oni_clone() {
  rm -rf oni2
  git clone https://github.com/ratmav/oni2
  msg "${OK}debian-oni-build: cloned source."
}

oni_debian() {
  oni_debian_fuse
  oni_debian_dependencies
}

oni_debian_fuse() {
  if dpkg -l | grep -w fuse > /dev/null 2>&1; then
    msg "${OK}debian_fuse: fuse already installed."
  else
    quiet "sudo apt-get install -y fuse"
    quiet "sudo modprobe fuse"

    quiet "sudo groupadd fuse"
    user="$(whoami)"
    quiet "sudo usermod -a -G fuse $user"

    msg "${WARN}debian_fuse: installed fuse; relogin likely required."
  fi
}

oni_debian_dependencies() {
  packages=("apt-utils" "build-essential" "libtool" "gettext" "nasm" "libacl1-dev"
    "libncurses-dev" "libglu1-mesa-dev" "libxxf86vm-dev" "libxkbfile-dev"
    "git-core" "curl" "libpng-dev" "libbz2-dev" "m4" "xorg-dev"
    "libharfbuzz-dev" "libgtk-3-dev" "libfontconfig1-dev" "clang"
    "software-properties-common" "dialog" "wget" "gpg")
  for package in "${packages[@]}"; do
    if dpkg -l | grep -w $package > /dev/null 2>&1; then
      msg "${OK}debian_oni_dependencies: $package already installed."
    else
      quiet "sudo apt-get install -y $package"
      msg "${OK}debian_oni_dependencies: installed $package."
    fi
  done
}

oni_macos() {
  oni_clone

  cd ./oni2

  #node install-node-deps.js
  #esy_build
  #esy_release
}

oni_release() {
  $NPM_CONFIG_PREFIX/bin/esy '@release' install
  $NPM_CONFIG_PREFIX/bin/esy '@release' run -f --checkhealth
  $NPM_CONFIG_PREFIX/bin/esy '@release' create

  msg "${OK} debian-oni-build: release built."
}
