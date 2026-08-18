{
  inputs,
  pkgs,
  ...
}: {
  services = {
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
#      displayManager.sessionCommands = ''
#        feh --bg-scale ~/.dotfiles/wallpaper/powerlines.jpg
#        xrandr --output DP-2 --primary --mode 1920x1080 --rate 240
#      '';
    };
  };
}
