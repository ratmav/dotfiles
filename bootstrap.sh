#!/bin/bash

source ./bash/mac_os.sh
source ./bash/linux.sh


configure_git_editor() {
  echo "configuring git editor..."
  git config --global core.editor "$(which vim)"
  echo "...configured"
}

configure_gitignore() {
  echo "configuring global gitignore..."
  git config --global core.excludesfile "$HOME/.gitignore_global"
  echo "...configured"
}

check_symlinks() {
  echo "checking symlinks..."
  files=(".bashrc" ".bash_profile" ".gitignore_global" ".ansible.cfg"
         ".spacemacs" "intel_asm_reference.pdf")
  for file in "${files[@]}"; do
    if [[ -h ~/$file ]]; then
      echo "...link present for $file"
    else
      ln -s "$PWD/$file" "$HOME/$file"
      echo "...linked $file"
    fi
  done
}

system_specific_tasks() {
  if [[ $(uname) == "Darwin" ]]; then
    echo "Running Mac-specific checks..."
    bootstrap_mac_os
  elif [[ $(uname) == "Linux" ]]; then
    echo "Running Linux-specific checks..."
    bootstrap_linux
  fi
}

main() {
  check_symlinks
  configure_gitignore
  configure_git_editor
  system_specific_tasks
}

main "$@"
