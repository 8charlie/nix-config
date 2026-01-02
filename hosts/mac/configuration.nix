{pkgs, ...}: {
  nix.settings.experimental-features = "nix-command flakes";

  imports = [../../modules/common/packages.nix ../../modules/common/neovim.nix ../../modules/mac/packages.nix ../../modules/mac/homebrew.nix];
  nixpkgs.config.allowUnfree = true;
  programs.fish.enable = true;
}
