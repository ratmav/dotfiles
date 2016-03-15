#!/bin/bash

echo "copying dotfiles to home directory..."
cp -R ./ ~/
echo "..done\n"

echo "installing fonts..."
fc-cache -f -v
echo "..done\n"

echo "configuring global gitignore..."
git config --global core.excludesfile '~/.gitignore'
echo "..done\n"
