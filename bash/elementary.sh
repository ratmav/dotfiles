#!/usr/bin/env bash

elementary_clean() {
  packages=("epiphany-browser" "epiphany-browser-data" "pantheon-mail"
    "maya-calendar" "maya-calendar-daemon" "noise" "audience" "pantheon-photos"
    "io.elementary.code" "appcenter")
  for package in "${packages[@]}"; do
    if dpkg -l | grep -w $package > /dev/null 2>&1; then
      quiet "sudo apt-get remove -y $package"
      msg "${OK}elementary_clean: removed $package."
    else
      msg "${OK}elementary_clean: $package already removed."
    fi
  done
}

elementary_virtualbox() {
  if dpkg -l | grep -wq virtualbox; then
    msg "${OK}elementary_virtualbox: virtualbox already installed."
  else
    quiet "sudo apt-get install -y virtualbox"
    msg "${OK}elementary_virtualbox: installed virtualbox."
  fi
}

main_elementary() {
  if grep -q "elementary OS" /etc/issue; then
    elementary_clean
    elementary_virtualbox
  else
    die "main_elementary: unsupported operating system."
  fi
}
