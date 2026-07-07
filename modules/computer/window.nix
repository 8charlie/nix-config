{
  inputs,
  pkgs,
  ...
}: {
  services.displayManager.ly.enable = true;

  programs.niri.enable = true;

  imports = [
    inputs.dms.nixosModules.dank-material-shell
  ];
  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = false;
  };

  services.dbus.enable = true;

  programs.ssh.enableAskPassword = false;
  services.gnome.gnome-keyring.enable = false;

  #services.desktopManager.plasma6.enable = true;
  #programs.hyprland.enable = true;

  services = {
    picom.enable = true;
    xserver = {
      videoDrivers = ["nvidia"];
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
      windowManager = {
        #       xmonad = {
        #         enable = true;
        #         enableContribAndExtras = true;
        #         extraPackages = hpkgs: [
        #           pkgs.rofi
        #           hpkgs.xmonad
        #           hpkgs.xmonad-extras
        #           hpkgs.xmonad-contrib
        #         ];
        #       };
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
        feh --bg-scale ~/.dotfiles/hosts/desktop/wallpaper/The_Artists_Garden_at_Eragny.png
        xrandr --output DP-2 --primary --mode 1920x1080 --rate 240
      '';
    };
  };
}
