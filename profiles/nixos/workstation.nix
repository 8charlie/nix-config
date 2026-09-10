{
  imports = [
    ./base.nix
    ../../modules/common/neovim.nix
    ../../modules/nixos/home-manager.nix
    ../../modules/nixos/boot/quiet.nix
    ../../modules/nixos/desktop/audio.nix
    ../../modules/nixos/desktop/defaults.nix
    ../../modules/nixos/desktop/fonts.nix
    ../../modules/nixos/desktop/packages.nix
    ../../modules/nixos/direnv.nix
    ../../modules/nixos/gc.nix
    ../../modules/nixos/man.nix
    ../../modules/nixos/nix-ld.nix
    ../../modules/nixos/security.nix
    ../../modules/nixos/xdg.nix
  ];

  services.resolved.enable = true;
}
