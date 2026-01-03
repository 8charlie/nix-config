{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = lib.collectNix ./modules/linux ++ lib.collectNix ./modules/common;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  #services.printing.enable = true;

  # so that portal definitions and de provided configurations get linked?
  environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  documentation.man.generateCaches = false; # very slow rebuild times if enabled

  programs.ssh.enableAskPassword = false;
  services.gnome.gnome-keyring.enable = false;

  programs.fish.enable = true;
  users.users.charlie = {
    isNormalUser = true;
    description = "charlie";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  home-manager.users.charlie = {pkgs, ...}: {
    home.stateVersion = "25.11";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "25.11";
}
