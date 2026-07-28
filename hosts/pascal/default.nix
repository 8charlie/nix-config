{config, ...}: {
  imports = [./hardware.nix];

  # GTX 1080
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

  # disable the UHD 630 iGPU (no BIOS option for it); keeps it out of Vulkan
  boot.blacklistedKernelModules = ["i915"];
  boot.kernelParams = ["module_blacklist=i915"];
}
