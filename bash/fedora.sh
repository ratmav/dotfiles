#!/usr/bin/env/bash

fedora_brave() {
  if grep -q "Fedora" /etc/system-release; then
    fedora_update
    if dnf list --installed | grep -w brave-browser > /dev/null 2>&1; then
      msg "${WARN}fedora_brave: brave already installed."
    else
      quiet "sudo dnf install -y dnf-plugins-core"
      quiet "sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/"
      quiet "sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc"
      quiet "sudo dnf install -y brave-browser"
      msg "${OK}fedora_brave: installed brave."
    fi
  else
    die "fedora_brave: unsupported operating system."
  fi
}

fedora_dependencies() {
  if grep -q "Fedora" /etc/system-release; then
    fedora_update
    packages=("neovim" "powerline-fonts" "pandoc")
    for package in "${packages[@]}"; do
      if dnf list --installed | grep -w $package > /dev/null 2>&1; then
        msg "${WARN}fedora_dependencies: $package already installed."
      else
        quiet "sudo dnf install -y $package"
        msg "${OK}fedora_dependencies: installed $package."
      fi
    done
  else
    die "fedora_dependencies: unsupported operating system."
  fi
}

fedora_update() {
  if grep -q "Fedora" /etc/system-release; then
    quiet "sudo dnf update -y"
    msg "${OK}fedora_update: system updated."
  else
    die "fedora_update: unsupported operating system."
  fi
}

main_fedora() {
  if grep -q "Fedora" /etc/system-release; then
    fedora_dependencies
    fedora_brave
  else
    die "main_fedora: unsupported operating system."
  fi
}
