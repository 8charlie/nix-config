{lib, ...}: {
  imports = lib.collectNix ../../modules/server;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.fish.enable = true;

  documentation.man.generateCaches = false; # very slow rebuild times if enabled
  system.stateVersion = "25.11";
}
