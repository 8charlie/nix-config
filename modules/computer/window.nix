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
    niri = {
      enable = false;
    };
    hyprland = {
      enable = false;
    };
  };
  services = {
    gnome.gnome-keyring.enable = true;

    displayManager.ly.enable = true;
    xserver = {
      videoDrivers = ["nvidia"];
      enable = true;
      autoRepeatDelay = 500;
      autoRepeatInterval = 40;
      windowManager = {
        xmonad = {
          enable = false;
          enableContribAndExtras = true;
          extraPackages = hpkgs: [
            pkgs.rofi
            hpkgs.xmonad
            hpkgs.xmonad-extras
            hpkgs.xmonad-contrib
          ];
        };
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
  environment.systemPackages = with pkgs; [
    # wayland
    wl-clipboard
    wlr-randr
    wmenu
    xwayland-satellite
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

    # x11
    rofi
  ];
}
