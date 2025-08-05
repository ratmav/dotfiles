let
  stable = import <nixpkgs> { };
  unstable = import <nixpkgs-unstable> { };
  gdk = stable.google-cloud-sdk.withExtraComponents( with stable.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]);
in
(with stable; [
  awscli2
  azure-cli
  curl
  direnv
  gh
  git
  gnugrep
  opentofu
  gnused
])
++ [ gdk ]
++ (with unstable; [ uv ])
