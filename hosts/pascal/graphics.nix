{config, ...}: {
  services.xserver.videoDrivers = ["nvidia"];

  # GTX 1080
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };
}
