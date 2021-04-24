#!/usr/bin/env/bash

debian_dependencies() {
  if grep -q "Debian" /etc/issue; then
    debian_update

    packages=("apt-transport-https" "build-essential" "ca-certificates" "clamav"
      "curl" "dirmngr" "gawk" "git" "gpg" "gnupg" "lsb-release" "neovim"
      "shellcheck" "software-properties-common" "htop" "pandoc")
    for package in "${packages[@]}"; do
      if dpkg -l | grep -w $package > /dev/null 2>&1; then
        msg "${OK}debian_dependencies: $package already installed."
      else
        quiet "sudo apt-get install -y $package"
        msg "${OK}debian_dependencies: installed $package."
      fi
    done
  else
    die "debian_dependencies: unsupported operating system."
  fi
}

debian_docker() {
  if grep -q "Debian" /etc/issue; then
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
  else
    die "debian_docker: unsupported operating system."
  fi
}

debian_etcher() {
  if grep -q "Debian" /etc/issue; then
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
  else
    die "debian_etcher: unsupported operating system."
  fi
}

debian_firefox_developer_edition() {
  if grep -q "Debian" /etc/issue; then
    rm -rf ./firefox
    ffde_url="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
    curl --location $ffde_url  | tar --extract --verbose --preserve-permissions --bzip2
    # TODO: move to /usr/local/bin or wherever is in path and writable w/o sudo.
  else
    die "debian_firefox_developer_edition: unsupported operating system."
  fi
}

debian_signal() {
  if grep -q "Debian" /etc/issue; then
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
  else
    die "debian_signal: unsupported operating system."
  fi
}

debian_update() {
  if grep -q "Debian" /etc/issue; then
    quiet "sudo apt-get update"
    quiet "sudo apt-get upgrade -y"
    msg "${OK}debian_update: system updated."
  else
    die "debian_update: unsupported operating system."
  fi
}

debian_vagrant() {
  if grep -q "Debian" /etc/issue; then
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
  else
    die "debian_vagrant: unsupported operating system."
  fi
}

debian_virtualbox() {
  if grep -q "Debian" /etc/issue; then
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
  else
    die "debian_virtualbox: unsupported operating system."
  fi
}

main_debian() {
  if grep -q "Debian" /etc/issue; then
    debian_etcher
    debian_signal
    debian_docker
    debian_virtualbox
    debian_firefox_developer_edition

    msg "${WARN}main_debian: docker-compose needs manual installation from https://github.com/docker/compose/releases/latest"
    msg "${WARN}main_debian: uhk agent needs manual installation from https://github.com/UltimateHackingKeyboard/agent/releases/latest"
    msg "${WARN}main_debian: cutter needs manual installation from https://cutter.re/download/"
    msg "${WARN}main_debian: neovide needs to be downloaded from https://github.com/Kethku/neovide/actions"
  else
    die "main_debian: unsupported operating system."
  fi
}
