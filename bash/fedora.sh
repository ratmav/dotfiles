#!/usr/bin/env/bash

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
  else
    die "main_fedora: unsupported operating system."
  fi
}
