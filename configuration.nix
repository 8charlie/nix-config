{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = lib.collectNix ./modules;
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  documentation.man.generateCaches = false; # very slow rebuild times if enabled

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
  home-manager.users.charlie = {pkgs, ...}: {
    home.stateVersion = "25.11";
  };
  system.stateVersion = "25.11";
}
