#!/usr/bin/env/bash

# TODO:
# set up a vargrant image and do this to keep the metal clean.
# * install packages you need
#   * signal: https://signal.org/download/#
#   * vagrant: https://www.hashicorp.com/blog/announcing-the-hashicorp-linux-repository
#   * docker: https://docs.docker.com/engine/install/debian/
#   * virtualbox: https://tecadmin.net/install-virtualbox-on-debian-10-buster/

debian_brave() {
  packages=("apt-transport-https" "curl" "gnupg")
  for package in "${packages[@]}"; do
    if dpkg -l | grep -w $package > /dev/null 2>&1; then
      msg "${OK}debian_brave: $package already installed."
    else
      quiet "sudo apt-get install -y $package"
      msg "${OK}debian_brave: installed $package."
    fi
  done

  sudo rm -f /etc/apt/sources.list.d/brave-browser-release.list
  sudo bash -c 'echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"\
    >| /etc/apt/sources.list.d/brave-browser-release.list'
  msg "${OK}debian_brave: configured apt."

  curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc\
    | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
  msg "${OK}debian_brave: gpg key added."

  quiet "sudo apt-get update"
  quiet "sudo apt-get install brave-browser -y"
  msg "${OK}debian_brave: installed brave."
}

debian_dependencies() {
  packages=("build-essential" "shellcheck" "gnupg" "clamav" "git")
  for package in "${packages[@]}"; do
    if dpkg -l | grep -w $package > /dev/null 2>&1; then
      msg "${OK}debian_dependencies: $package already installed."
    else
      quiet "sudo apt-get install -y $package"
      msg "${OK}debian_dependencies: installed $package."
    fi
  done
}

debian_update() {
  quiet "sudo apt-get update"
  quiet "sudo apt-get upgrade -y"
  msg "${OK}debian_update: system updated."
}

main_debian() {
  debian_update
  debian_dependencies
  debian_brave

  msg "${WARN}main_debian: docker-compose needs manual installation from https://github.com/docker/compose/releases/latest"
  msg "${WARN}main_debian: uhk agent needs manual installation from https://github.com/UltimateHackingKeyboard/agent/releases/latest"
}
