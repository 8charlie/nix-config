{ config, pkgs, ... }:

{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "nixos";
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

  # nvidia drivers
  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;

    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  #  hardware.bluetooth = {
  #  enable = true;
  #  powerOnBoot = true;
  #  settings = {
  #    General = {
  #      Experimental = true;
  #      # When enabled other devices can connect faster to us, however
  #      # the tradeoff is increased power consumption. Defaults to
  #      # 'false'.
  #      FastConnectable = true;
  #    };
  #    Policy = {
  #      AutoEnable = true;
  #    };
  #  };
  #};

  #  services.ofono.enable = true;  # maybe delete
  #services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #    wireplumber.enable = true;  # maybe delete
    #    wireplumber.extraConfig.bluetoothEnhancements = {
    #      "monitor.bluez.properties" = {
    #        "bluez5.enable-sbc-xq" = true;
    #        "bluez5.enable-msbc" = true;
    #        "bluez5.enable-hw-volume" = true;
    #        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
    #      };
    #    };
  };
  services.displayManager.ly.enable = true;

  services.xserver.enable = true;
  #services.desktopManager.plasma6.enable = true;

  #services.printing.enable = true; # Enable CUPS to print documents.

  documentation.man.generateCaches = false; # very slow rebuild times if enabled

  programs.fish.enable = true;
  programs.niri.enable = true;
  users.users.charlie = {
    isNormalUser = true;
    description = "charlie";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    packages = [ ];
  };

  home-manager.users.charlie =
    { pkgs, ... }:
    {
      home.stateVersion = "25.11";
    };

  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
