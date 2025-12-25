{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
    };
    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    lanzaboote,
    mangowc,
    home-manager,
    ...
  }: let
    lib = nixpkgs.lib.extend (
      final: prev:
        import ./lib.nix {lib = final;}
    );
    commonModules = [
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
    # System builder function
    mkSystem = {
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
          ++ commonModules;
      };
  in {
    nixosConfigurations = {
      home = mkSystem {
        hostname = "home";
        hardwareModule = ./hosts/home/hardware.nix;
      };
      nixos = mkSystem {
        hostname = "nixos";
        hardwareModule = ./hosts/nixos/hardware.nix;
      };
    };
  };
}
