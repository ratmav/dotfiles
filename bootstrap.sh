#!/bin/bash

source ./bash/mac_os.sh
source ./bash/linux.sh

LINKS=(".bashrc" ".bash_profile" ".gitignore_global" ".ansible.cfg"
  ".vimrc" ".tmux.conf")

configure_gitignore() {
  echo "configuring global gitignore..."
  git config --global core.excludesfile "$HOME/.gitignore_global"
  echo "...configured"
}

configure_git_editor() {
  echo "configuring git editor..."
  git config --global core.editor "$(which vim)"
  echo "...configured"
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

symlinks_build() {
  echo "building new symlinks..."
  for link in "${LINKS[@]}"; do
    ln -s $PWD/$link $HOME/$link
    echo "...linked $link"
  done
}

symlinks_clean() {
  echo "cleaning old symlinks/files..."
  for link in "${LINKS[@]}"; do
    rm -rf $HOME/$link
    echo "...cleaned $link"
  done
}

vim-plug() {
  echo "checking vim-plug install..."
  rm -rf "$HOME/.vim"
  echo "...cleaned old vim-plug install"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "...installed vim-plug"
}

main() {
  symlinks_clean
  symlinks_build
  vim-plug
  configure_gitignore
  configure_git_editor
  operating_system
}

main "$@"
