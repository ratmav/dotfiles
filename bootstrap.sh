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
  files=(".gitignore_global" ".ansible.cfg" ".spacemacs"
         "intel_asm_reference.pdf")
  for file in "${files[@]}"; do
    if [[ -h ~/$file ]]; then
      echo "...link present for $file"
    else
      ln -s "$PWD/$file" "$HOME/$file"
      echo "...linked $file"
    fi
  done
}

local_bash_profile() {
  echo "checking bash profile"
  if [[ -h $HOME/.bash_profile ]]; then
    echo "...bash profile link exists"
  elif [[ -f $HOME/.bash_profile ]]; then
    echo "...bash profile is file"
    cp "$HOME/.bash_profile" "$HOME/.local_bash_profile"
    echo "...moved current bash profile to local bash profile"
    rm -f "$HOME/.bash_profile"
    echo "...removed old bash profile."
    ln -s "$PWD/.bash_profile" "$HOME/.bash_profile"
    echo "...linked bash_profile"
  else
    echo "......bash profile missing?"
    ln -s "$PWD/.bash_profile" "$HOME/.bash_profile"
    echo "......linked bash_profile"
  fi
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
  local_bash_profile
  check_symlinks
  configure_gitignore
  configure_git_editor
  system_specific_tasks
}

main "$@"
