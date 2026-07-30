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
      # release branch, not master: master tracks nixpkgs-unstable, which would
      # put the mac on a different nixpkgs (and home-manager) than everything else
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
    self,
    nixpkgs,
    nixpkgs-unstable,
    lanzaboote,
    dms,
    nix-darwin,
    nix-homebrew,
    home-manager,
    ...
  }: let
    lib = nixpkgs.lib.extend (
      final: prev:
        import ./lib.nix {lib = final;}
    );
    commonModules = lib.collectNix ./modules/common;
    # home-manager runs as a nixos/nix-darwin module; the user config lives in ./home
    hmModule = username: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        # rename instead of failing activation when a file already exists
        backupFileExtension = "hm-bak";
        extraSpecialArgs = {inherit inputs;};
        users.${username} = import ./home;
      };
    };
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
            (hmModule "charlie")
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
        specialArgs = {inherit inputs lib;};
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
            home-manager.darwinModules.home-manager
            (hmModule username)
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
