{inputs, ...}: {
  imports = [
    ./systemd-boot.nix
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    loader = {
      systemd-boot = {
        configurationLimit = 8;
      };
      timeout = 0;
    };
    kernelParams = ["quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3"];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
}
