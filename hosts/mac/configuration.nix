{pkgs, ...}:
{
  imports = [ ../../modules/common/packages.nix ../../modules/mac/packages.nix ../../modules/mac/homebrew.nix ];
  nixpkgs.config.allowUnfree = true;
}
