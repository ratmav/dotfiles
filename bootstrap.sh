#!/bin/bash

source ./bootstrap/mac_os.sh
source ./bootstrap/linux.sh


declare -a FILES=(".tmux.conf" ".vimrc" ".gitignore_global" ".ansible.cfg"
                  "Scripts")

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

# NOTE: Can't link because nesting is too deep via Git submodules.
copy_vim_submodules() {
  echo "copying vim submodules..."
  rm -rf ~/.vim
  mkdir ~/.vim
  cp -r vim_submodules/* ~/.vim/
  echo "...copied submodules"
}

check_symlinks() {
  echo "checking symlinks..."
  for FILE in "${FILES[@]}"; do
    if [[ -h ~/$FILE ]]; then
      echo "...link present for $FILE"
    else
      ln -s "$PWD/$FILE" "$HOME/$FILE"
      echo "...linked $FILE"
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
  copy_vim_submodules
  configure_gitignore
  configure_git_editor
  system_specific_tasks
}

main "$@"
