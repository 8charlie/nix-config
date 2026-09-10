{
  imports = [
    ./hardware.nix
    ./power.nix
    ../../profiles/nixos/server.nix
    ../../modules/nixos/services/nextcloud.nix
    ../../modules/nixos/services/tailscale.nix
  ];

  networking.hostName = "server";
  nixpkgs.hostPlatform = "x86_64-linux";

  services.nextcloud.hostName = "server.tail824f34.ts.net";

  system.stateVersion = "25.11";
}
