{ config, pkgs, lib, ... }:

let
  unstable = import <nixpkgs-unstable> { };

  # AWS CLI without Python tests (speeds up builds)
  awscli2-no-tests = unstable.awscli2.overrideAttrs (oldAttrs: {
    doCheck = false;
    doInstallCheck = false;
  });

  # Google Cloud SDK with GKE plugin
  gcp = unstable.google-cloud-sdk.withExtraComponents (
    with unstable.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]
  );

  # Platform-specific packages
  darwinPackages = lib.optionals pkgs.stdenv.isDarwin [
    unstable.reattach-to-user-namespace
    unstable.bash-completion
  ];

  linuxPackages = lib.optionals pkgs.stdenv.isLinux [
    unstable.opensnitch  # Linux firewall
  ];

in {
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "25.05";

  # Core packages (cross-platform from unstable)
  home.packages = (with unstable; [
    # Shell & Core Utils
    bash
    coreutils
    curl
    gnugrep
    gnused
    ripgrep
    shellcheck

    # Development Tools
    git
    gh
    direnv

    # Cloud Infrastructure
    azure-cli
    opentofu
    goose-cli

    # Security Tools
    cosign
    gnupg

    # Document Processing
    pandoc
    librsvg
    python3
    (texlive.combine {
      inherit (texlive) scheme-basic;
    })

    # Terminals & Editors
    wezterm
    neovim

    # Package Managers
    uv

    # Browsers
    brave
  ]) ++ [ awscli2-no-tests gcp ] ++ darwinPackages ++ linuxPackages;

  # Neovim configuration
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    # Use external paq-nvim manager, just load our config
    extraLuaConfig = ''
      dofile(vim.fn.expand("~/Source/dotfiles/neovim.lua"))
    '';
  };

  # WezTerm configuration
  home.file.".wezterm.lua".source = ../wezterm.lua;

  # Git configuration
  programs.git = {
    enable = true;
    extraConfig = {
      core = {
        editor = "nvim";
        excludesfile = "~/.gitignore_global";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };

  # Bash configuration (replaces .bashrc)
  programs.bash = {
    enable = true;
    enableCompletion = true;

    bashrcExtra = ''
      # Environment
      export PS1="[\u@\h \W]\\$ "
      export CLICOLOR=1
      export DIRENV_LOG_FORMAT=""
      export DOCKER_CLI_HINTS=false

      # Source custom helpers
      if [ -f "$HOME/Source/dotfiles/helpers/bash/init.sh" ]; then
        source "$HOME/Source/dotfiles/helpers/bash/init.sh"
      fi

      ${lib.optionalString pkgs.stdenv.isDarwin ''
        # macOS-specific
        export HOMEBREW_NO_ANALYTICS=1
        export PATH="/Library/TeX/Root/bin/universal-darwin:$PATH"
      ''}

      # Makefile completion
      _make_completion() {
        local cur prev targets
        COMPREPLY=()
        cur="''${COMP_WORDS[COMP_CWORD]}"
        prev="''${COMP_WORDS[COMP_CWORD-1]}"
        targets=$(make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);print A[1]}' | sort -u)
        COMPREPLY=( $(compgen -W "''${targets}" -- ''${cur}) )
        return 0
      }
      complete -F _make_completion make

      # Host-specific overrides
      if [ -f "$HOME/.this_machine" ]; then
        source "$HOME/.this_machine"
      fi
    '';
  };

  # direnv integration
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Other dotfiles
  home.file.".gitignore_global".source = ../.gitignore_global;
  home.file.".bash_profile".source = ../.bash_profile;

  programs.home-manager.enable = true;
}
