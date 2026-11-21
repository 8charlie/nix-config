{
  imports = [./wayland.nix];

  programs.niri.enable = true;

  xdg.portal.config.niri = {
    default = ["gnome" "gtk"];
    "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
    "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
    # the gnome portal's file chooser is Nautilus, which glitches outside a
    # GNOME session (save dialogs stuck in an empty location, e.g. Zotero's
    # export); the plain GTK chooser works
    "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
  };
}
