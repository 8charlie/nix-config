{
  imports = [./wayland.nix];

  programs.niri.enable = true;

  xdg.portal.config.niri = {
    default = ["gnome" "gtk"];
    "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
    "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
  };
}
