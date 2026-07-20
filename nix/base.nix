let
  stable = import <nixpkgs> { };
  unstable = import <nixpkgs-unstable> { };
  gdk = stable.google-cloud-sdk.withExtraComponents( with stable.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]);
in
stable.buildEnv {
  name = "base-environment";
  paths = (with stable; [
    awscli2
    curl
    direnv
    gh
    git
    gnugrep
    opentofu
    gnused
  ])
  ++ [ gdk ]
  ++ (with unstable; [
        azure-cli
        devenv
        goose-cli
        uv
      ]);
}
