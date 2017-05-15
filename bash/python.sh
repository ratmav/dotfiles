#!/bin/bash


pypi_packages() {
  packages=(pip setuptools virtualenv pep8 ansible)
  for package in ${packages[@]}; do
    echo "...checking $package install..."
    if type "$package" > /dev/null 2>&1; then
      echo "......$package already installed"
    else
      source "$HOME/.bashrc" && pip install -U "$package"
      echo "...installed $1..."
    fi
  done
}
