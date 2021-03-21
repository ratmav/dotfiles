#!/usr/bin/env/bash

# TODO:
# set up a vargrant image and do this to keep the metal clean.
# * uninstall packages you don't need
#   * kate
#   * yaquake
#   * konversation
# * install packages you need
#   * brave
#   * tresorit
#   * vagrant
#   * docker (just in case)
#   * asdf
#   * shellcheck (also set up a github action on this repo)
#   * signal
#   * steam/proton/etc.
#   * battle.net
#   * uhk agent
#   * oni (after getting the rest; markdown preview? probably a vscode extension)

install_docker() {

}

detect_distro() {
  if cat /etc/issue | grep Manjaro > /dev/2>&1; then
    install_docker
  else
      echo "......non-supported linux distribution."
  fi
}

bootstrap_linux() {
  detect_distro
}
