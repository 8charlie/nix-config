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
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    lanzaboote,
    dms,
    ...
  }: let
    lib = nixpkgs.lib.extend (
      final: prev:
        import ./lib.nix {lib = final;}
    );
    commonModules = lib.collectNix ./modules/common;
    mkComputer = {
      hostname,
      hostModule,
    }:
      lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs lib;};
        modules =
          commonModules
          ++ [
            ./config/computer/configuration.nix
            hostModule
            {networking.hostName = hostname;}
            lanzaboote.nixosModules.lanzaboote
          ];
      };
    mkServer = {
      hostname,
      hostModule,
    }:
      lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs lib;};
        modules =
          commonModules
          ++ [
            ./config/server/configuration.nix
            hostModule
            {networking.hostName = hostname;}
          ];
      };
  in {
    nixosConfigurations = {
      desktop = mkComputer {
        hostname = "desktop";
        hostModule = ./hosts/desktop;
      };
      glass = mkComputer {
        hostname = "glass";
        hostModule = ./hosts/glass;
      };
      server = mkServer {
        hostname = "server";
        hostModule = ./hosts/server;
      };
    };
  };
}
