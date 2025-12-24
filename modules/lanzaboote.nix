{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      #timeout = 5; # this doesn't work bc lanzaboote
      efi.canTouchEfiVariables = true;
    };
    kernelParams = ["quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3"];
  };
}
