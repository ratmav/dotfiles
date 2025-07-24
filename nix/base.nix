{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  curl
  direnv
  git
  grep
  sed
  uv
]
