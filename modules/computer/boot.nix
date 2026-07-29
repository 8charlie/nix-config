{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 8;
      };
      timeout = 1;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = ["quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3"];
  };
}
