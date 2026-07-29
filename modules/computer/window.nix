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
    sway = {
      enable = false;
      wrapperFeatures.gtk = true;
    };
    niri = {
      enable = true;
    };
    hyprland = {
      enable = false;
    };
    ssh.enableAskPassword = false;
  };
  services = {
    displayManager.ly.enable = true;
    xserver = {
      videoDrivers = ["nvidia"];
      enable = true;
      autoRepeatDelay = 500;
      autoRepeatInterval = 40;
      windowManager = {
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
        feh --bg-scale ~/.dotfiles/wallpaper/powerlines.jpg
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
  ];
}
