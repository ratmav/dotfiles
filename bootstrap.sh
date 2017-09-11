#!/bin/bash

source ./bash/mac_os.sh
source ./bash/linux.sh

LINKS=(".bashrc" ".bash_profile" ".gitignore_global")

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

nvim_init_symlink() {
  echo "(re)building nvim init symlink..."
  rm -rf $HOME/.config/nvim
  mkdir -p $HOME/.config/nvim
  ln -s $PWD/init.vim $HOME/.config/nvim/init.vim
  echo "...(re)built nvim init link"
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

vim-plug() {
  echo "checking vim-plug install..."
  rm -rf "$HOME/.local/share/nvim"
  echo "...cleaned old vim-plug install"
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "...installed vim-plug"
}

main() {
  vim-plug
  nvim_init_symlink
  home_symlinks
  configure_gitignore
  configure_git_editor
  operating_system
}

main "$@"
