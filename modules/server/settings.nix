{
  pkgs,
  config,
  ...
}: {
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";

  # battery cap
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 55;
      STOP_CHARGE_THRESH_BAT0 = 60;

      # Always on AC + lightly loaded → bias toward low power and low heat
      CPU_ENERGY_PERF_POLICY_ON_AC = "power";
      CPU_BOOST_ON_AC = 0; # disable turbo: cooler, lower draw, negligible for a personal Nextcloud
      PLATFORM_PROFILE_ON_AC = "low-power"; # only if your firmware exposes platform profiles
    };
  };

  services.thermald.enable = true; # Intel: proactive thermal mgmt, keeps it cool under sustained load
  services.fstrim.enable = true; # SSD longevity
  zramSwap.enable = true; # compressed RAM swap → far fewer SSD writes; also helps a low-RAM old box
  fileSystems."/".options = ["noatime"]; # stop writing an access timestamp on every read
  boot.kernelParams = ["consoleblank=60"]; # blank the panel after 60s idle (saves backlight, spares the screen)
  hardware.bluetooth.enable = false; # kill unused radios (skip if you actually use BT)
}
