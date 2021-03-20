#!/usr/bin/env/bash

# TODO:
# set up a vargrant image and do this to keep the metal clean.
# * install docker
# * run ansible in a container
# * configure ansible to use files in the repo
# * playbooks/tasks
#   * uninstall packages you don't need
#     * kate
#     * yaquake
#     * konversation
#   * install packages you need
#     * brave
#     * tresorit
#     * oni (markdown preview? probably a vscode extension)
#     * vagrant
#     * docker (just in case)
#     * asdf
#     * shellcheck (also set up a github action on this repo)
#     * signal
#     * steam/proton/etc.
#     * battle.net
#     * uhk agent
# * uninstall nvim (manually)
# * break symlinks?,

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
