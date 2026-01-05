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
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    lanzaboote,
    dms,
    caelestia-shell,
    ...
  }: let
    lib = nixpkgs.lib.extend (
      final: prev:
        import ./lib.nix {lib = final;}
    );
    commonModules = [
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
  };
}
