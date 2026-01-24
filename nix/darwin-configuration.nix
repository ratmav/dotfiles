{ config, pkgs, ... }:

{
  # Enable nix-darwin
  services.nix-daemon.enable = true;

  # Nix configuration
  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  # Use Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # System packages (macOS-specific system tools)
  environment.systemPackages = with pkgs; [
    # Minimal system tools only
  ];

  # Homebrew casks for macOS-specific GUI apps
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    casks = [
      "lulu"  # Objective-See firewall
    ];
  };

  # System defaults
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
  };

  # Home-manager integration
  users.users.${builtins.getEnv "USER"}.home = "/Users/${builtins.getEnv "USER"}";

  # Used for backwards compatibility
  system.stateVersion = 5;
}
