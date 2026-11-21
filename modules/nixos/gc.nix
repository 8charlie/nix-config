{
  # retention lives in modules/common/gc.nix; this is only NixOS scheduling
  nix.gc = {
    dates = "weekly";
    randomizedDelaySec = "45min";
  };

  nix.optimise.dates = ["weekly"];
}
