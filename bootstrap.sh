#!/bin/bash

declare -a FILES=(".tmux.conf" ".vimrc" ".gitignore_global" "Scripts")

check_homebrew() {

  echo "...checking homebrew install"
  if type brew >/dev/null 2>&1; then
    echo "......homebrew already installed"
  else
    URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
    /usr/bin/ruby -e "$(curl -fsSL $URL)"
    echo "......installed homebrew"
  fi
}

configure_git_editor() {
  echo "configuring git editor..."
  git config --global core.editor $(which vim)
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
  cp -r vim_submodules ~/.vim
  echo "...copied submodules"
}

copy_fonts() {
  echo "copying fonts..."
  cp fonts/* ~/Library/Fonts/
  echo "...copied fonts"
}

check_symlinks() {
  echo "checking symlinks..."
  for FILE in "${FILES[@]}"; do
    verify_symlink "$FILE"
  done
}

verify_symlink() {
  if [[ -h ~/$1 ]]; then
    echo "...link present for $1"
  else
    ln -s "$PWD/$1" "$HOME/$1"
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
  copy_vim_submodules
  copy_fonts
  configure_gitignore
  configure_git_editor
  if [[ $(uname) == "Darwin" ]]; then
    echo "Running Mac-specific checks..."
    check_homebrew
  fi
}

main "$@"
