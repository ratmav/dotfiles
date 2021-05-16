#!/usr/bin/env/bash

fedora_dependencies() {
  if grep -q "Fedora" /etc/system-release; then
    fedora_update
    packages=("bash-completion" "neovim" "pandoc")
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

fedora_wezterm() {
  if grep -q "Fedora" /etc/system-release; then
    if dnf list --installed | grep -w wezterm > /dev/null 2>&1; then
      msg "${WARN}fedora_wezterm: wezterm already installed."
    else
      fedora_version=$(awk '/^Fedora release/ { print $3 }' /etc/system-release)
      msg "${WARN}fedora_wezterm: detected fedora version $fedora_version."

      rpm_url="https://github.com/wez/wezterm/releases/download/20210502-154244-3f7122cb/wezterm-20210502_154244_3f7122cb-1.fc$fedora_version.x86_64.rpm"
      quiet "sudo dnf install -y $rpm_url"
      msg "${OK}fedora_wezterm: installed wezterm."
    fi
  else
    die "fedora_update: unsupported operating system."
  fi
}

main_fedora() {
  if grep -q "Fedora" /etc/system-release; then
    fedora_dependencies
    fedore_wezterm
  else
    die "main_fedora: unsupported operating system."
  fi
}
