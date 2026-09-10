{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      # Keep Darwin on the same release as nixpkgs and Home Manager.
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nix-darwin,
    ...
  }: let
    mkNixos = host:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [host];
      };
    mkDarwin = host:
      nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs;};
        modules = [host];
      };
  in {
    nixosConfigurations = {
      lovelace = mkNixos ./hosts/lovelace;
      pascal = mkNixos ./hosts/pascal;
      server = mkNixos ./hosts/server;
    };
    darwinConfigurations.m5 = mkDarwin ./hosts/m5;
  };
}
