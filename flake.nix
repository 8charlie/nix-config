{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
        nix-homebrew.url = "github:zhaofengli/nix-homebrew";
        homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
        homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    lanzaboote,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    mangowc,
    ...
  }: let
    lib = nixpkgs.lib.extend (
      final: prev:
        import ./lib.nix {lib = final;}
    );
    linuxModules = [
      mangowc.nixosModules.mango
      lanzaboote.nixosModules.lanzaboote
      ./modules/lanzaboote.nix
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
    commonModules = [
    ];
    mkDarwin = {
      hostname,
      darwinModule,
    }:
      nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
        specialArgs = {inherit inputs lib;};
          modules = [
            darwinModule
          {
                nix.settings.experimental-features = "nix-command flakes";
        system.stateVersion = 5;
        nixpkgs.hostPlatform = "aarch64-darwin";
          networking.hostName = hostname;
            }
      home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
                #users.charlie = import ./home-darwin.nix;
          extraSpecialArgs = {inherit inputs;};
          backupFileExtension = "backup";
        };
            }
                    nix-homebrew.darwinModules.nix-homebrew {
                      nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "charlie";
            autoMigrate = true;
          };
            }

          ];

      };
    mkLinux = {
      hostname,
      hardwareModule,
    }:
      lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs lib;};
        modules =
          [
            ./configuration.nix
            hardwareModule
            {networking.hostName = hostname;}
          ]
          ++ linuxModules
          ++ commonModules;
      };
  in {
    nixosConfigurations = {
      home = mkLinux {
        hostname = "home";
        hardwareModule = ./hosts/home/hardware.nix;
      };
      nixos = mkLinux {
        hostname = "nixos";
        hardwareModule = ./hosts/nixos/hardware.nix;
      };
    };
      darwinConfigurations = {
      mac = mkDarwin {
        hostname = "mac";
        darwinModule = ./hosts/mac/configuration.nix;
      };
      };
  };
}
