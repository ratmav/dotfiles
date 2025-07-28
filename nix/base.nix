let
  stable = import <nixpkgs> { };
  unstable = import <nixpkgs-unstable> { };
in
(with stable; [
  curl
  direnv
  git
  gnugrep
  opentofu
  gnused
])
++ (with unstable; [ uv ])
