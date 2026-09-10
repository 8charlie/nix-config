{inputs, ...}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Rename existing files instead of failing activation.
    backupFileExtension = "hm-bak";
    extraSpecialArgs = {inherit inputs;};
    users.charlie = import ../../home/profiles/workstation.nix;
  };
}
