{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = lib.collectNix ../../modules/server;
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/London";
  
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.charlie = {
    isNormalUser = true;
    description = "charlie";
    extraGroups = ["networkmanager" "wheel"];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  nixpkgs.config.allowUnfree = true;

  documentation.man.generateCaches = false; # very slow rebuild times if enabled

  system.stateVersion = "25.11";
}
