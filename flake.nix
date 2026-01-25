{
  description = "Personal development environment setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" "aarch64-linux" ];
    in
    {
      apps = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # Wrapper that sources _lib.sh and provides bash environment
          mkApp = scriptName: script: {
            type = "app";
            program = toString (pkgs.writeShellScript scriptName ''
              set -Eeuo pipefail
              trap 'echo "error occurred"' ERR
              trap 'echo "interrupted"' SIGINT
              trap 'echo "terminated"' SIGTERM

              script_dir="${self}"

              # Source library functions
              source ${self}/bash/_lib.sh

              # Source platform scripts
              source ${self}/bash/macos.sh
              source ${self}/bash/posix.sh
              source ${self}/bash/kali.sh

              setup_colors

              ${script}
            '');
          };
        in
        {
          # Full bootstrap (auto-detects OS)
          bootstrap = mkApp "bootstrap" ''
            if [[ $(uname) == "Darwin" ]]; then
              main_macos
              main_posix
            elif _is_kali; then
              main_kali
              main_posix
            else
              die "bootstrap: unsupported platform."
            fi
          '';

          # Granular commands
          macos = mkApp "macos" ''
            if [[ $(uname) == "Darwin" ]]; then
              main_macos
            else
              die "macos: unsupported operating system."
            fi
          '';

          kali = mkApp "kali" ''
            if _is_kali; then
              main_kali
            else
              die "kali: unsupported operating system."
            fi
          '';

          posix = mkApp "posix" ''
            main_posix
          '';

          # Individual function calls for testing
          macos-nix = mkApp "macos-nix" "macos_nix";
          macos-nix-darwin = mkApp "macos-nix-darwin" "macos_nix_darwin";
          macos-darwin-config = mkApp "macos-darwin-config" "macos_darwin_config";
          macos-home-manager = mkApp "macos-home-manager" "macos_home_manager";
          macos-home-config = mkApp "macos-home-config" "macos_home_config";
          macos-shell = mkApp "macos-shell" "macos_shell";

          kali-nix = mkApp "kali-nix" "kali_nix";
          kali-nix-config = mkApp "kali-nix-config" "kali_nix_config";
          kali-home-manager = mkApp "kali-home-manager" "kali_home_manager";
          kali-home-config = mkApp "kali-home-config" "kali_home_config";
          kali-shell = mkApp "kali-shell" "kali_shell";

          posix-nvim-paq = mkApp "posix-nvim-paq" "posix_nvim_paq";
        });

      # Default app is bootstrap
      defaultApp = forAllSystems (system: self.apps.${system}.bootstrap);
    };
}
