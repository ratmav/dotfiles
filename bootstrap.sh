#!/bin/bash

declare -a files=(".tmux.conf" ".vimrc" ".vim" ".gitignore_global" "Scripts")
declare -a fonts=(./fonts/*.otf)

check_homebrew() {
  echo "...checking homebrew install"
  if type brew >/dev/null 2>&1; then
    echo "......homebrew already installed"
  else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo "......installed homebrew"
  fi
}

configure_gitignore() {
  echo "configuring global gitignore..."
  git config --global core.excludesfile '~/.gitignore_global'
  echo "...configured"
}

copy_fonts() {
  echo "copying fonts..."
  for font in "${fonts[@]}"; do
    echo "COMMAND: cp $1 ~/Library/Fonts/"
    echo "...copied $1 font"
  done
}

check_symlinks() {
  echo "checking symlinks..." 
  for file in "${files[@]}"; do
    verify_symlink "$file"
  done
}

verify_symlink() {
  if [[ -h ~/$1 ]]; then
    echo "...link present for $1"
  else
    ln -s $PWD/$1 ~/$1
    echo "...linked $1"
  fi
}

overwrite_bash_profile() {
  echo "Overwriting bash profile..."
  rm -f ~/.bash_profile
  echo "...removed old bash profile"
  verify_symlink ".bash_profile"
}

main() {
  overwrite_bash_profile
  check_symlinks
  copy_fonts
  configure_gitignore
  if [[ `uname` == "Darwin" ]]; then
    echo "Running Mac-specific checks..."
    check_homebrew
  fi
}

main "$@"
