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
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    lanzaboote,
    dms,
    nix-darwin,
    nix-homebrew,
    ...
  }: let
    mkLib = pkgsFlake:
      pkgsFlake.lib.extend (
        final: prev:
          import ./lib.nix {lib = final;}
      );
    lib = mkLib nixpkgs;
    libDarwin = mkLib nixpkgs-unstable;
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
    mkMac = {
      username,
      hostname,
      hostModule,
      system ? "aarch64-darwin",
    }:
      nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
          lib = libDarwin;
        };
        modules =
          commonModules
          ++ [
            ./config/mac/configuration.nix
            hostModule
            {
              networking.hostName = hostname;
              nixpkgs.hostPlatform = system;
              # required by nix-darwin for anything user-scoped (homebrew, defaults)
              system.primaryUser = username;
              users.users.${username}.home = "/Users/${username}";
            }
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                user = username;
                # M-series: leave false unless you specifically need x86-only casks under Rosetta
                enableRosetta = false;
              };
            }
          ];
      };
  in {
    nixosConfigurations = {
      lovelace = mkComputer {
        hostname = "lovelace";
        hostModule = ./hosts/lovelace;
      };
      pascal = mkComputer {
        hostname = "pascal";
        hostModule = ./hosts/pascal;
      };
      server = mkServer {
        hostname = "server";
        hostModule = ./hosts/server;
      };
    };
    darwinConfigurations = {
      m5 = mkMac {
        username = "charlie";
        hostname = "m5";
        hostModule = ./hosts/m5;
      };
    };
  };
}
