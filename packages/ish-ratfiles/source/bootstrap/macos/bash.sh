#!/usr/bin/env bash

ish_ratfiles_bootstrap_macos_bash() {
  if [[ $(ish_platform_os) != "macos" ]]; then
    ish_tui_error --message="${FUNCNAME[0]}: unsupported operating system."
    return 1
  fi

  bash_path='/opt/homebrew/bin/bash'
  file='/etc/shells'

  grep -qF -- "$bash_path" "$file" || echo "$bash_path" | sudo tee -a "$file" > /dev/null
  chsh -s $bash_path
  ish_tui_info --message="${FUNCNAME[0]}: configured macos to use homebrew's bash."
}
