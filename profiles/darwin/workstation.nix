{
  imports = [
    ../../modules/common
    ../../modules/common/neovim.nix
    ../../modules/darwin/defaults.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/darwin/packages.nix
    ../../modules/darwin/user.nix
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };
}
