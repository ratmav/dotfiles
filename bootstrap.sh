#!/bin/bash

echo "copying tmux config..."
cp .tmux.conf ~/
echo "..done"

echo "copying vim config and plugins..."
cp .vimrc ~/
cp -R .vim ~/
echo "..done"

echo "installing fonts..."
cp -R .fonts ~/
fc-cache -f -v >> /dev/null &>/dev/null # STFU.
echo "..done"

echo "installing scripts..."
printf "\nexport PATH=\"\$PATH:\$HOME/Scripts\"" >> ~/.profile
cp -R Scripts ~/
echo "..done"

echo "configuring global gitignore..."
cp .gitignore_global ~/
git config --global core.excludesfile '~/.gitignore_global'
echo "..done"
