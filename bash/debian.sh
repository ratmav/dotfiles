#!/usr/bin/env/bash

# TODO:
# set up a vargrant image and do this to keep the metal clean.
# * install packages you need
#   * brave
#   * tresorit
#   * vagrant
#   * docker (just in case)
#   * shellcheck (also set up a github action on this repo)
#   * signal
#   * steam/proton/etc.
#   * battle.net
#   * uhk agent
#   * oni (after getting the rest; markdown preview? probably a vscode extension)

debian_fuse() {
  if dpkg -l | grep -w fuse > /dev/null 2>&1; then
    msg "${OK}debian_fuse: fuse already installed."
  else
    sudo apt-get install -y fuse > /dev/null 2>&1
    sudo modprobe fuse

    sudo groupadd fuse > /dev/null
    user="$(whoami)"
    sudo usermod -a -G fuse $user

    msg "${WARN}debian_fuse: installed fuse; relogin likely required."
  fi
}

debian_oni_dependencies() {
  PACKAGES=("apt-utils" "build-essential" "libtool" "gettext" "nasm" "libacl1-dev"
    "libncurses-dev" "libglu1-mesa-dev" "libxxf86vm-dev" "libxkbfile-dev"
    "git-core" "curl" "libpng-dev" "libbz2-dev" "m4" "xorg-dev"
    "libharfbuzz-dev" "libgtk-3-dev" "libfontconfig1-dev" "clang"
    "software-properties-common" "dialog" "wget" "gpg")
  for package in "${PACKAGES[@]}"; do
    if dpkg -l | grep -w $package > /dev/null 2>&1; then
      msg "${OK}debian_oni_dependencies: $package already installed."
    else
      sudo apt-get install -y $package > /dev/null 2>&1
      msg "${OK}debian_oni_dependencies: installed $package."
    fi
  done

  debian_fuse
}

debian_update() {
  sudo apt-get update > /dev/null 2>&1
  sudo apt-get upgrade -y > /dev/null 2>&1
  msg "${OK}debian_update: system updated."
}

main_debian() {
  debian_update
  debian_oni_dependencies
  debian_brave
}
