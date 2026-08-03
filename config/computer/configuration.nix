{lib, ...}: {
  imports = lib.collectNix ../../modules/computer;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "45min";
    options = "--delete-older-than 14d";
  };
  documentation.man.cache.enable = false; # very slow rebuild times if enabled

  system.stateVersion = "25.11";
}
