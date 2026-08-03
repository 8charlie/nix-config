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
    #displayManager.ly.enable = true;
    displayManager.dms-greeter = {
      compositor = {
        name = "niri"; # Required. Can be also "hyprland" or "sway"
      };
      # Sync your user's DankMaterialShell theme with the greeter. You'll probably want this
      configHome = "/home/charlie";
      # Custom config files for non-standard config locations
      configFiles = [
        "/home/charlie/.config/DankMaterialShell/settings.json"
      ];
      # Save the logs to a file
      logs = {
        save = true;
        path = "/tmp/dms-greeter.log";
      };
    };
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
