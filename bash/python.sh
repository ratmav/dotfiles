#!/bin/bash


pypi_packages() {
  packages=(pip setuptools flake8 ansible)
  for package in ${packages[@]}; do
    echo "...(re)installing $package"
    pip install -U "$package" 1>/dev/null
  done
}
