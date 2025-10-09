{ config, pkgs, ... }:

let
  unstable = import <nixpkgs-unstable> { };
  gdk = unstable.google-cloud-sdk.withExtraComponents(
    with unstable.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]
  );
in {
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "25.05";

  home.packages = (with unstable; [
    awscli2
    azure-cli
    curl
    direnv
    gh
    git
    gnugrep
    gnused
    goose-cli
    opentofu
    ripgrep
    uv
  ]) ++ [ gdk ];

  programs.home-manager.enable = true;
}
