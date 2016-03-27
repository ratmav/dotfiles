#!/bin/bash

echo "copying dotfiles to home directory..."
cp -R ./ ~/
echo "..done"

echo "installing fonts..."
fc-cache -f -v
echo "..done"

echo "configuring global gitignore..."
git config --global core.excludesfile '~/.gitignore'
echo "..done"
