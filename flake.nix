{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      inputs.nixpkgs.follows = "nixpkgs-unstable"; # this line is optional, prevents downloading two versions of nixpkgs but disables cache
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
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
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.charlie = import ./home.nix;
                extraSpecialArgs = {inherit inputs;};
                backupFileExtension = "backup";
              };
            }
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
