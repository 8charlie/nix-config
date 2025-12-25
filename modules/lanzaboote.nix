{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.sbctl];
  boot = {
    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
      };
      #timeout = 5; # this doesn't work bc lanzaboote
      efi.canTouchEfiVariables = true;
    };
    kernelParams = ["quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3"];
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
