{config, ...}: {
  imports = [./hardware.nix];

  # GTX 1080
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
}
