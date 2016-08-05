#!/bin/bash

# echo "installing fonts..."
# fc-cache -f -v >> /dev/null &>/dev/null # STFU.
# 
# echo "installing scripts..."
# printf "\nexport PATH=\"\$PATH:\$HOME/Scripts\"" >> ~/.bashrc
# 
# echo "configuring global gitignore..."
# git config --global core.excludesfile '~/.gitignore_global'

declare -a files=(".tmux.conf" ".vimrc" ".vim" ".gitignore_global" "Scripts")

symlink() {
  echo "COMMAND: ln -s $1 ~/$1"
}

link_files() {
  echo "...linking..." 
  for file in "${files[@]}"; do
    symlink "$file"
    echo "....linked $file.."
  done
}

install_fonts() {
  cp fonts/* ~/Library/Fonts/
}

link_files
# WIP:  Install fonts.
# TODO: Append to .bashrc for script path.
# TODO: Configure global gitignore.
# TODO: Remove NERDTree, use netrw.
# TODO: Make this idempotent - i.e, check for links first, check for font files first, check for script path in .bashrc.
# TODO: Swap .bashrc for .bash_profile?
# TODO: Install homebrew if it isn't present.
# FIND: Dump and save iTerm preferences?
