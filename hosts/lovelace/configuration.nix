{
  imports = [
    ../../modules/computer/audio.nix
    ../../modules/computer/boot.nix
    ../../modules/computer/desktop.nix
    ../../modules/computer/direnv.nix
    ../../modules/computer/display.nix
    ../../modules/computer/fonts.nix
    ../../modules/computer/game.nix
    ../../modules/computer/gc.nix
    ../../modules/computer/helium.nix
    ../../modules/computer/ld.nix
    ../../modules/computer/man.nix
    ../../modules/computer/neovim.nix
    ../../modules/computer/network.nix
    ../../modules/computer/packages.nix
    ../../modules/computer/security.nix
    ../../modules/computer/shell.nix
    ../../modules/computer/tailscale.nix
    ../../modules/computer/wayland.nix
    ../../modules/computer/x11.nix
    ../../modules/computer/xdg.nix
  ];

  system.stateVersion = "25.11";
}
