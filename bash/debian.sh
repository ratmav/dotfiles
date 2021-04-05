#!/usr/bin/env/bash

debian_brave() {
  if dpkg -l | grep -w brave-browser > /dev/null 2>&1; then
    msg "${OK}debian_brave: brave-browser already installed."
  else
    msg "${WARN}debian_brave: installing brave-browser."
    debian_dependencies

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
  debian_update

  packages=("apt-transport-https" "build-essential" "ca-certificates" "clamav"
    "curl" "dirmngr" "gawk" "git" "gpg" "gnupg" "lsb-release" "neovim"
    "shellcheck" "software-properties-common")
  for package in "${packages[@]}"; do
    if dpkg -l | grep -w $package > /dev/null 2>&1; then
      msg "${OK}debian_dependencies: $package already installed."
    else
      quiet "sudo apt-get install -y $package"
      msg "${OK}debian_dependencies: installed $package."
    fi
  done
}

debian_docker() {
  if dpkg -l | grep -w docker > /dev/null 2>&1; then
    msg "${OK}debian_docker: docker already installed."
  else
    msg "${WARN}debian_docker: installing docker."
    debian_dependencies

    rm -f docker-archive-keyring.gpg
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor > docker-archive-keyring.gpg
    sudo mv docker-archive-keyring.gpg /usr/share/keyrings/docker-archive-keyring.gpg
    msg "${OK}debian_docker: gpg key added."

    sudo rm -f /etc/apt/sources.list.d/docker.list
    sudo bash -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg]\
      https://download.docker.com/linux/debian buster stable"\
      >| /etc/apt/sources.list.d/docker.list'
    msg "${OK}debian_docker: configured apt."

    quiet "sudo apt-get update"
    quiet "sudo apt-get install docker-ce docker-ce-cli containerd.io -y"
    msg "${OK}debian_docker: installed docker."
  fi
}

debian_etcher() {
  if dpkg -l | grep -w balena-etcher-electron > /dev/null 2>&1; then
    msg "${OK}debian_etcher: etcher already installed."
  else
    msg "${WARN}debian_etcher: installing etcher."
    debian_dependencies

    sudo rm -f /etc/apt/sources.list.d/balenda-etcher.list
    sudo bash -c 'echo "deb https://deb.etcher.io stable etcher" >| /etc/apt/sources.list.d/balena-etcher.list'
    msg "${OK}debian_etcher: configured apt."

    quiet "sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys 379CE192D401AB61"
    msg "${OK}debian_etcher: gpg key added."

    quiet "sudo apt-get update"
    quiet "sudo apt-get install balena-etcher-electron -y"
    msg "${OK}debian_etcher: installed etcher."
  fi
}
debian_shared() {
  debian_etcher
  debian_brave
  debian_signal
  debian_docker

  msg "${WARN}main_debian: hyper needs manual installation from https://hyper.is/#installation"
  msg "${WARN}main_debian: docker-compose needs manual installation from https://github.com/docker/compose/releases/latest"
  msg "${WARN}main_debian: uhk agent needs manual installation from https://github.com/UltimateHackingKeyboard/agent/releases/latest"
  msg "${WARN}main_debian: cutter needs manual installation from https://cutter.re/download/"
}

debian_signal() {
  if dpkg -l | grep -w signal-desktop > /dev/null 2>&1; then
    msg "${OK}debian_signal: signal-desktop already installed."
  else
    msg "${WARN}debian_signal: installing signal."
    debian_dependencies

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

debian_update() {
  quiet "sudo apt-get update"
  quiet "sudo apt-get upgrade -y"
  msg "${OK}debian_update: system updated."
}

debian_vagrant() {
  if dpkg -l | grep -w vagrant > /dev/null 2>&1; then
    msg "${OK}debian_vagrant: vagrant already installed."
  else
    msg "${WARN}debian_vagrant: installing vagrant."
    debian_dependencies

    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    msg "${OK}debian_vagrant: gpg key added."

    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    msg "${OK}debian_vagrant: configured apt."

    quiet "sudo apt-get update"
    quiet "sudo apt-get install vagrant -y"
    msg "${OK}debian_vagrant: installed vagrant."
  fi
}

debian_virtualbox() {
  if dpkg -l | grep -w virtualbox-6.1 > /dev/null 2>&1; then
    msg "${OK}debian_virtualbox: virtualbox already installed."
  else
    msg "${WARN}debian_virtualbox: installing virtualbox."
    debian_dependencies

    curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
    msg "${OK}debian_virtualbox: gpg key added."

    sudo apt-add-repository "deb http://download.virtualbox.org/virtualbox/debian buster contrib"
    msg "${OK}debian_virtualbox: configured apt."

    quiet "sudo apt-get update"
    quiet "sudo apt-get install virtualbox-6.1 -y"
    msg "${OK}debian_virtualbox: installed virtualbox."
  fi
}

main_debian() {
  if grep -q "Debian" /etc/issue; then
    debian_shared
    debian_virtualbox
  elif grep -q "elementary OS" /etc/issue; then
    debian_shared
  else
    die "main_debian: unsupported operating system."
  fi
}
