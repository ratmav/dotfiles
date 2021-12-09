#!/usr/bin/env/bash

fedora_dependencies() {
  if grep -q "Fedora" /etc/system-release; then
    fedora_update
    packages=("shellcheck" "bash-completion" "neovim" "pandoc")
    for package in "${packages[@]}"; do
      if dnf list --installed | grep -w $package > /dev/null 2>&1; then
        msg "${WARN}${FUNCNAME[0]}: $package already installed."
      else
        quiet "sudo dnf install -y $package"
        msg "${OK}${FUNCNAME[0]}: installed $package."
      fi
    done
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

fedora_update() {
  if grep -q "Fedora" /etc/system-release; then
    quiet "sudo dnf update -y"
    msg "${OK}${FUNCNAME[0]}: system updated."
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

fedora_wezterm() {
  if grep -q "Fedora" /etc/system-release; then
    if dnf list --installed | grep -w wezterm > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: wezterm already installed."
    else
      fedora_version=$(awk '/^Fedora release/ { print $3 }' /etc/system-release)
      msg "${WARN}${FUNCNAME[0]}: detected fedora version $fedora_version."

      rpm_url="https://github.com/wez/wezterm/releases/download/20210502-154244-3f7122cb/wezterm-20210502_154244_3f7122cb-1.fc$fedora_version.x86_64.rpm"
      quiet "sudo dnf install -y $rpm_url"
      msg "${OK}${FUNCNAME[0]}: installed wezterm."
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

main_fedora() {
  if grep -q "Fedora" /etc/system-release; then
    fedora_dependencies
    fedore_wezterm
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}
