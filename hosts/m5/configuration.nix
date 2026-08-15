{lib, ...}: {
  imports = [lib.collectNix ../../modules/mac] ++ ../../modules/computer/neovim.nix;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };

  time.timeZone = "Europe/London";

  system.stateVersion = 6;
}
