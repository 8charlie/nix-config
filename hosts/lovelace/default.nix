{config, ...}: {
  imports = [./hardware.nix];

  programs.helium-browser = {
    enable = true;
    makeDefault = true;
  };

  # RTX 4070
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia = {
    open = true;
    modesetting.enable = false;
  };
}
