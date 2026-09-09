{
  imports = [
    ../../modules/server/boot.nix
    ../../modules/server/network.nix
    ../../modules/server/nextcloud.nix
    ../../modules/server/packages.nix
    ../../modules/server/settings.nix
    ../../modules/server/shell.nix
    ../../modules/server/tailscale.nix
  ];

  documentation.man.generateCaches = false; # very slow rebuild times if enabled
  system.stateVersion = "25.11";
}
