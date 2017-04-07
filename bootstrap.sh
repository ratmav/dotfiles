#!/bin/bash

source ./bootstrap/mac_os.sh
source ./bootstrap/linux.sh


declare -a FILES=(".bash_profile" ".tmux.conf" ".vimrc" ".gitignore_global"
                  ".ansible.cfg" "Scripts")

bash_profile() {
  echo "...checking bash profile"
  if [[ -L $HOME/.bash_profile ]]; then
    echo "......bash profile symlink exists"
  else
    cp "$HOME/.bash_profile" "$HOME/.local_bash_profile"
    echo "......moved current bash profile to local bash profile"
    rm -f "$HOME/.bash_profile"
    echo "......removed old bash profile."
  fi
}

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
  bash_profile
  for FILE in "${FILES[@]}"; do
    if [[ -h ~/$FILE ]]; then
      echo "...link present for $FILE"
    else
      ln -s "$PWD/$FILE" "$HOME/$FILE"
      echo "...linked $FILE"
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
  copy_vim_submodules
  configure_gitignore
  configure_git_editor
  system_specific_tasks
}

main "$@"
