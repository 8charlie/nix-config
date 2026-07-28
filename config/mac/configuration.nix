{lib, ...}: {
  imports = [../../modules/computer/neovim.nix] ++ lib.collectNix ../../modules/mac;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };

  time.timeZone = "Europe/London";

  system.stateVersion = 6;
}
