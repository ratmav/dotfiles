#!/usr/bin/env/bash

# TODO:
# set up a vargrant image and do this to keep the metal clean.
# * install packages you need
#   * vagrant: https://www.hashicorp.com/blog/announcing-the-hashicorp-linux-repository
#   * docker: https://docs.docker.com/engine/install/debian/
#   * virtualbox: https://tecadmin.net/install-virtualbox-on-debian-10-buster/

debian_brave() {
  if dpkg -l | grep -w brave-browser > /dev/null 2>&1; then
    msg "${OK}debian_brave: brave-browser already installed."
  else
    packages=("apt-transport-https" "curl" "gnupg")
    for package in "${packages[@]}"; do
      if dpkg -l | grep -w $package > /dev/null 2>&1; then
        msg "${OK}debian_brave: $package already installed."
      else
        quiet "sudo apt-get install -y $package"
        msg "${OK}debian_brave: installed $package."
      fi
    done

    curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc\
      | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
    msg "${OK}debian_brave: gpg key added."

    sudo rm -f /etc/apt/sources.list.d/brave-browser-release.list
    sudo bash -c 'echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"\
      >| /etc/apt/sources.list.d/brave-browser-release.list'
    msg "${OK}debian_brave: configured apt."

    quiet "sudo apt-get update"
    quiet "sudo apt-get install brave-browser -y"
    msg "${OK}debian_brave: installed brave-browser."
  fi
}

debian_dependencies() {
  packages=("build-essential" "clamav" "git" "shellcheck")
  for package in "${packages[@]}"; do
    if dpkg -l | grep -w $package > /dev/null 2>&1; then
      msg "${OK}debian_dependencies: $package already installed."
    else
      quiet "sudo apt-get install -y $package"
      msg "${OK}debian_dependencies: installed $package."
    fi
  done
}

debian_signal() {
  if dpkg -l | grep -w signal-desktop > /dev/null 2>&1; then
    msg "${OK}debian_signal: signal-desktop already installed."
  else
    if dpkg -l | grep -w curl > /dev/null 2>&1; then
      msg "${OK}debian_signal: curl already installed."
    else
      quiet "sudo apt-get install -y curl"
      msg "${OK}debian_signal: installed curl."
    fi

    rm -f signal-desktop-keyring.gpg
    curl -s https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
    sudo mv signal-desktop-keyring.gpg /usr/share/keyrings/
    msg "${OK}debian_signal: gpg key added."

    sudo rm -f /etc/apt/sources.list.d/signal-xenial.list
    sudo bash -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] \
      https://updates.signal.org/desktop/apt xenial main" >| /etc/apt/sources.list.d/signal-xenial.list'
    msg "${OK}debian_signal: configured apt."

    quiet "sudo apt-get update"
    quiet "sudo apt-get install signal-desktop -y"
    msg "${OK}debian_signal: installed signal desktop."
  fi
}

debian_vagrant() {
  if dpkg -l | grep -w vagrant > /dev/null 2>&1; then
    msg "${OK}debian_vagrant: vagrant already installed."
  else
    packages=("software-properties-common" "curl")
    for package in "${packages[@]}"; do
      if dpkg -l | grep -w $package > /dev/null 2>&1; then
        msg "${OK}debian_vagrant: $package already installed."
      else
        quiet "sudo apt-get install -y $package"
        msg "${OK}debian_vagrant: installed $package."
      fi
    done

    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    msg "${OK}debian_vagrant: gpg key added."

    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    msg "${OK}debian_vagrant: configured apt."

    quiet "sudo apt-get update"
    quiet "sudo apt-get install vagrant -y"
    msg "${OK}debian_vagrant: installed vagrant."
  fi
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
  debian_signal

  msg "${WARN}main_debian: docker-compose needs manual installation from https://github.com/docker/compose/releases/latest"
  msg "${WARN}main_debian: uhk agent needs manual installation from https://github.com/UltimateHackingKeyboard/agent/releases/latest"
}
