{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = lib.collectNix ../../modules/computer;
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  documentation.man.generateCaches = false; # very slow rebuild times if enabled

  system.stateVersion = "25.11";
}
