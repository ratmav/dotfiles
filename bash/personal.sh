#!/usr/bin/env/bash

personal_debian_signal() {
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
