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

  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  #services.desktopManager.plasma6.enable = true;
  #programs.hyprland.enable = true;

  #services.xserver = {
  #  enable = true;
  #  videoDrivers = ["nvidia"];
  #  displayManager.sessionCommands = ''
  #    xrandr --output DP-0 --mode 2560x1440 --rate 270
  #    xset r rate 300 30
  #  '';
  #  windowManager.i3 = {
  #    enable = true;
  #    extraPackages = with pkgs; [
  #      autotiling
  #      dmenu
  #      feh
  #      i3status
  #    ];
  #  };
  #};
}
