{pkgs, ...}: {
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERM = "xterm-ghostty";

    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";

    XDG_DOWNLOAD_DIR = "$HOME/Downloads";
    XDG_DOCUMENTS_DIR = "$HOME/Documents";
    XDG_PICTURES_DIR = "$HOME/Pictures";

    # Qt apps like the Nextcloud client fall back to GTK3's file chooser, which
    # needs the org.gtk.Settings.FileChooser GSettings schema. gtk3 is installed
    # but under niri its schemas aren't on the global search path, so the lookup
    # turns fatal (SIGTRAP). Expose gtk3's schema dir as an extra search path.
    GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
  };

  # set default apps
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gnome xdg-desktop-portal-gtk];
      config = {
        common = {
          default = ["gtk"];
        };
        niri = {
          default = ["gtk" "gnome"];
          "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
          "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
        };
      };
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "nautilus.desktop";
        "image/png" = "feh.desktop";
        "image/jpeg" = "feh.desktop";
        "text/plain" = "nvim.desktop";
        "text/html" = "librewolf.desktop";
        "video/mp4" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
      };
    };
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };
}
