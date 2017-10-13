#!/bin/bash

source ./bash/mac_os.sh
source ./bash/linux.sh

LINKS=(".atom" ".bashrc" ".bash_profile" ".gitignore_global")

configure_gitignore() {
  echo "configuring global gitignore..."
  git config --global core.excludesfile "$HOME/.gitignore_global"
  echo "...configured"
}

configure_git_editor() {
  echo "configuring git editor..."
  git config --global core.editor "$(which nvim)"
  echo "...configured"
}

home_symlinks() {
  echo "(re)building new symlinks..."
  for link in "${LINKS[@]}"; do
    rm -rf $HOME/$link
    ln -s $PWD/$link $HOME/$link
    echo "...(re)built $link link"
  done
}

operating_system() {
  if [[ $(uname) == "Darwin" ]]; then
    echo "Running Mac-specific checks..."
    bootstrap_mac_os
  elif [[ $(uname) == "Linux" ]]; then
    echo "Running Linux-specific checks..."
    bootstrap_linux
  fi
}

main() {
  home_symlinks
  #operating_system
  #configure_gitignore
  #configure_git_editor
}

main "$@"
