{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.dms.nixosModules.dank-material-shell
  ];
  programs = {
    dank-material-shell = {
      enable = true;
      enableSystemMonitoring = false;
    };
    ssh.enableAskPassword = false;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };

  #programs.niri.enable = true;
  #services.desktopManager.plasma6.enable = true;
  #programs.hyprland.enable = true;

  services = {
    #dbus.enable = true;
    #gnome.gnome-keyring.enable = false;

    displayManager.ly.enable = true;
    xserver = {
      videoDrivers = ["nvidia"];
      enable = true;
      #autoRepeatDelay = 400;
      autoRepeatInterval = 40;
      windowManager = {
        #  xmonad = {
        #    enable = true;
        #    enableContribAndExtras = true;
        #    extraPackages = hpkgs: [
        #      pkgs.rofi
        #      hpkgs.xmonad
        #      hpkgs.xmonad-extras
        #      hpkgs.xmonad-contrib
        #    ];
        #  };
        i3 = {
          enable = true;
          extraPackages = with pkgs; [
            autotiling
            dmenu
            feh
            i3status
          ];
        };
      };
      displayManager.sessionCommands = ''
        feh --bg-scale ~/.dotfiles/hosts/desktop/wallpaper/Birmingham_Museums_Trust_Unsplash.jpg
        xrandr --output DP-2 --primary --mode 1920x1080 --rate 240
      '';
    };
  };
}
