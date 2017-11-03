#!/bin/bash


pypi_packages() {
  packages=(pip setuptools flake8)
  for package in ${packages[@]}; do
    pip install -U "$package"
  done
}
