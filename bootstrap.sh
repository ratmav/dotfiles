#!/bin/bash

source ./bash/mac_os.sh
source ./bash/linux.sh

LINKS=(
  ".bashrc"
  ".bash_profile"
  ".gitignore_global"
  )

configure_gitignore() {
  echo "...(re)configuring global gitignore"
  git config --global core.excludesfile "$HOME/.gitignore_global"
}

configure_git_editor() {
  echo "...(re)configuring git editor"
  git config --global core.editor "code --wait"
}

home_symlinks() {
  echo "...(re)building symlinks"
  for link in "${LINKS[@]}"; do
    rm -rf $HOME/$link
    ln -s $PWD/$link $HOME/$link
    echo "......(re)built $link"
  done
}

operating_system() {
  if [[ $(uname) == "Darwin" ]]; then
    bootstrap_mac_os
  elif [[ $(uname) == "Linux" ]]; then
    bootstrap_linux
  fi
}


main() {
  operating_system
  home_symlinks
  configure_gitignore
  configure_git_editor
}

main "$@"