{
  services.displayManager.ly.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };

  programs.dms-shell.enable = true;

  programs.niri.enable = true;
  programs.hyprland.enable = true;
  programs.mango.enable = true;
}
