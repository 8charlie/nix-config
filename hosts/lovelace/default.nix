{
  imports = [
    ./graphics.nix
    ./hardware.nix
    ../../profiles/nixos/workstation.nix
    ../../modules/nixos/desktop/niri.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/i3.nix
    ../../modules/nixos/desktop/dms-greeter.nix
    ../../modules/nixos/gaming.nix
  ];

  networking.hostName = "lovelace";
  nixpkgs.hostPlatform = "x86_64-linux";

  systemd.services.NetworkManager-wait-online.enable = false;

  system.stateVersion = "25.11";
}
