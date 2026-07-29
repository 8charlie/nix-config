{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 8;
      };
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = ["quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3"];
    consoleLogLevel = 0;
    initrd.verbose = false;
    blacklistedKernelModules = ["tpm_tis" "tpm_crb"];
  };
  # disable tpm for faster boot
  systemd.services.systemd-tpm2-setup.enable = false;
  systemd.services.systemd-tpm2-setup-early.enable = false;
}
