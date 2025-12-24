{
  services.displayManager.ly.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };

  programs.niri.enable = true;
  programs.hyprland.enable = true;
  programs.mango.enable = true;
}
