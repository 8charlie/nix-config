{
  imports = [
    ../../profiles/darwin/workstation.nix
  ];

  networking.hostName = "m5";
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.stateVersion = 6;
}
