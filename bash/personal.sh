#!/usr/bin/env/bash

personal_debian_firefox_developer_edition() {
  if grep -q "Debian" /etc/issue; then
    if [ -f "/opt/firefox/firefox"]; then
      msg "${WARN}personal_debian_firefox_developer_edition: firefox developer edition already installed."
    else
      quiet "sudo apt-get remove -y firefox"
      rm -rf ./firefox
      ffde_url="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
      curl --location $ffde_url  | tar --extract --verbose --preserve-permissions --bzip2
      sudo mv ./firefox /opt/
      sudo ln -s /opt/firefox/firefox /usr/bin/firefox
      msg "${OK}personal_debian_firefox_developer_edition: firefox devloper edition installed."
    fi
  else
    die "personal_debian_firefox_developer_edition: unsupported operating system."
  fi
}

personal_debian_signal() {
  if grep -q "Debian" /etc/issue; then
    if dpkg -l | grep -w signal-desktop > /dev/null 2>&1; then
      msg "${WARN}personal_debian_signal: signal-desktop already installed."
    else
      debian_dependencies

      rm -f signal-desktop-keyring.gpg
      curl -s https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
      sudo mv signal-desktop-keyring.gpg /usr/share/keyrings/
      msg "${OK}personal_debian_signal: gpg key added."

      sudo rm -f /etc/apt/sources.list.d/signal-xenial.list
      sudo bash -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] \
        https://updates.signal.org/desktop/apt xenial main" >| /etc/apt/sources.list.d/signal-xenial.list'
      msg "${OK}personal_debian_signal: configured apt."

      quiet "sudo apt-get update"
      quiet "sudo apt-get install signal-desktop -y"
      msg "${OK}personal_debian_signal: installed signal desktop."
    fi
  else
    die "personal_debian_signal: unsupported operating system."
  fi
}

personal_macos_cask_packages() {
  if [[ $(uname) == "Darwin" ]]; then
    PACKAGES=("signal" "firefox-developer-edition")
    for package in "${PACKAGES[@]}"; do
      if brew list --cask | grep $package > /dev/null 2>&1; then
        msg "${WARN}personal_macos_cask_packages: $package already installed."
      else
        quiet "brew install --cask $package"
        msg "${OK}personal_macos_cask_packages: installed $package via homebrew cask."
      fi
    done
  else
    die "personal_macos_cask_packages: unsupported operating system."
  fi
}
