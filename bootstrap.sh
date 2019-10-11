#!/bin/bash

source ./bash/mac_os.sh
source ./bash/linux.sh

configure_gitignore() {
  echo "...(re)configuring global gitignore"
  git config --global core.excludesfile "$HOME/.gitignore_global"
}

configure_git_editor() {
  echo "...(re)configuring git editor"
  git config --global core.editor "$(which nvim)"
}

home_symlinks() {
  LINKS=(".bashrc" ".bash_profile" ".gitignore_global" ".tmux.conf")
  echo "...(re)building symlinks"
  for link in "${LINKS[@]}"; do
    rm -rf $HOME/$link
    ln -s $PWD/$link $HOME/$link
    echo "......(re)built $link"
  done
}

nvim_init() {
  echo "...configuring nvim"
  rm -rf $HOME/.config/nvim
  mkdir -p $HOME/.config/nvim
  ln -s $PWD/init.vim $HOME/.config/nvim/init.vim
}

vim_plug() {
  echo "...installing vim-plug"
  rm -rf $HOME/.local/share/nvim
  URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs -s $URL
}

tpm() {
  echo "...installing tpm"
  rm -f $HOME/.tmux/plugins
  mkdir -p ~/.tmux/plugins
  git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

operating_system() {
  if [[ $(uname) == "Darwin" ]]; then
    bootstrap_mac_os
  elif [[ $(uname) == "Linux" ]]; then
    bootstrap_linux
  fi
}

powerline_fonts() {
  git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts
}

main() {
  #operating_system
  #tpm
  #home_symlinks
  #nvim_init
  #vim_plug
  #configure_gitignore
  #configure_git_editor
  powerline_fonts
}

main "$@"
