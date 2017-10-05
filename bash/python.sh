#!/bin/bash


pypi_packages() {
  packages=(pip setuptools powerline-status)
  for package in ${packages[@]}; do
    pip install -U "$package"
  done
}
