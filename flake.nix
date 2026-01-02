{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
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
    ];
    commonModules = [
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
    mkDarwin = {
      hostname,
      darwinModule,
    }:
      nix-darwin.lib.darwinSystem {
        nixpkgs.hostPlatform = "aarch-darwin";
        system.stateVersion = 6;
        services.nix-daemon.enable = true;
        specialArgs = {inherit inputs lib;};
        modules =
          [darwinModule]
          {networking.hostName = hostname;}
          ++ commonModules;
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
      macbook = mkDarwin {
        hostname = "mac";
        darwinModule = ./hosts/macbook/default.nix;
      };
    };
  };
}
