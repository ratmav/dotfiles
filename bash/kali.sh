#!/usr/bin/env/bash

source ./bash/_lib.sh


kali_dependencies() {
  if _is_kali; then
    packages=("curl" "neovim")

    quiet "sudo apt-get update"

    for package in "${packages[@]}"; do
      quiet "sudo apt-get install -y $package"
      msg "${OK}${FUNCNAME[0]}: installed $package."
    done
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

kali_rust() {
  if _is_kali; then
    if type cargo > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: rust/cargo already installed."
    else
      curl --proto '=https' -tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

kali_wezterm() {
  if _is_kali; then
    if type wezterm > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: wezterm already installed."
    else
      local gpg_key_url="https://apt.fury.io/wez"
      local gpg_key_path="/etc/apt/keyrings/wezterm-fury.gpg"
      local apt_source_content="deb [signed-by=$gpg_key_path] $gpg_key_url/ * *"
      local apt_source_path="/etc/apt/sources.list.d/wezterm.list"

      curl -fsSL "$gpg_key_url/gpg.key" | sudo gpg --yes --dearmor -o "$gpg_key_path"
      echo "$apt_source_content" | sudo tee "$apt_source_path"

      sudo apt-get update
      sudo apt-get install wezterm -y

      msg "${OK}${FUNCNAME[0]}: installed $package."
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

main_kali() {
  if _is_kali; then
    kali_dependencies
    kali_rust
    kali_wezterm
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}
