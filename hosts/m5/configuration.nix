{
  imports = [
    ../../modules/mac/homebrew.nix
    ../../modules/mac/packages.nix
    ../../modules/mac/settings.nix
    ../../modules/mac/shell.nix
    ../../modules/computer/neovim.nix
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };

  time.timeZone = "Europe/London";

  system.stateVersion = 6;
}
