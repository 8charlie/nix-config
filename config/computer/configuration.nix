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

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };

  programs.fish.enable = true;
  users.users.charlie = {
    isNormalUser = true;
    description = "charlie";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  system.stateVersion = "26.05";
}
