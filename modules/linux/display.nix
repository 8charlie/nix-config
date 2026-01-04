{
  services.displayManager.ly.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };

  programs.dms-shell = {
    enable = true;
    systemd.enable = false;
  };

  programs.niri.enable = true;
  programs.hyprland.enable = true;
  programs.mango.enable = true;
}
