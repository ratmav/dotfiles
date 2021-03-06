#!/usr/bin/env bash

source ./bash/mac_os.sh
source ./bash/linux.sh

configure_git() {
  echo "...(re)configuring global gitignore"
  git config --global core.excludesfile "$HOME/.gitignore_global"

  echo "...(re)configuring git editor"
  git config --global core.editor "$(which nvim)"

  echo "...(re)configuring git to connect to gitlab over ssh"
  git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"
}

home_symlinks() {
  LINKS=(".bashrc" ".bash_profile" ".gitignore_global" ".hyper.js")
  echo "...(re)building symlinks"
  for link in "${LINKS[@]}"; do
    rm -rf $HOME/$link
    ln -s $PWD/$link $HOME/$link
    echo "......(re)built $link"
  done
}

configure_nvim() {
  echo "...(re)building nvim symlinks"
  rm -rf $HOME/.config/nvim
  mkdir -p $HOME/.config/nvim
  ln -s $PWD/init.vim $HOME/.config/nvim/init.vim

  echo "...installing vim-plug"
  rm -rf $HOME/.local/share/nvim
  URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs -s $URL

  echo "...installing plugins"
  nvim +PlugInstall +qall
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

asdf() {
  rm -rf $HOME/.asdf
  git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf
}

main() {
  operating_system
  home_symlinks
  configure_git
  configure_nvim
  vim_plug
  powerline_fonts
  asdf
}

main "$@"
