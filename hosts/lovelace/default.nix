{config, ...}: {
  imports = [./hardware.nix];

  # RTX 4070
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
}
