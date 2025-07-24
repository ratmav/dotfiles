{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  curl
  direnv
  git
  gnugrep
  opentofu
  gnused
  uv
]
