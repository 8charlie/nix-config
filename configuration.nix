{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
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

  services.xserver.enable = true;

  services.displayManager.ly.enable = true;
  services.desktopManager.plasma6.enable = true;
  #services.displayManager.sddm.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #  services.pulseaudio.enable = false;
  #  security.rtkit.enable = true;
  #  services.pipewire = {
  #    enable = true;
  #    alsa.enable = true;
  #    alsa.support32Bit = true;
  #    pulse.enable = true;
  #    # If you want to use JACK applications, uncomment this
  #    #jack.enable = true;
  #
  #    # use the example session manager (no others are packaged yet so this is enabled by default,
  #    # no need to redefine it in your config for now)
  #    #media-session.enable = true;
  #  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.charlie = {
    isNormalUser = true;
    description = "charlie";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ kdePackages.kate ];
  };

  home-manager.users.charlie = { pkgs, ... }: {
    programs.bash.enable = true;
    home.stateVersion = "25.05";
  };

  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [ vim wget ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.graphics = {
		enable = true;
	};
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
	nvidiaSettings = true;

	open = false;
	package = config.boot.kernelPackages.nvidiaPackages.stable;
	};

  system.stateVersion = "25.05";
}
