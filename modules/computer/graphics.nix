{config, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    #package = config.boot.kernelPackages.nvidiaPackages.stable; # this should be used for 4070
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };
}
