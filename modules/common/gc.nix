{
  # shared by NixOS and nix-darwin; scheduling options differ per platform
  # (NixOS: dates, darwin: interval), so modules/nixos/gc.nix sets those there.
  # darwin's defaults are already weekly.
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  nix.optimise.automatic = true;
}
