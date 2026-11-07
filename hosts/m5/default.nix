{
  imports = [
    ../../profiles/darwin/workstation.nix
    ../../modules/common/latex.nix
  ];

  networking.hostName = "m5";
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.stateVersion = 6;
}
