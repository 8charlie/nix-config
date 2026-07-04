{lib, ...}: {
  imports = lib.collectNix ../../modules/computer;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };
  documentation.man.cache.enable = false; # very slow rebuild times if enabled

  system.stateVersion = "25.11";
}
