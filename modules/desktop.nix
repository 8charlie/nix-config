{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.dankMaterialShell.homeModules.dankMaterialShell.default];
  programs.dankMaterialShell.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERM = "xterm-ghostty";

    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";

    XDG_DOWNLOAD_DIR = "$HOME/down";
    XDG_DOCUMENTS_DIR = "$HOME/doc";
    XDG_PICTURES_DIR = "$HOME/pics";
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

  gtk = {
    enable = true;
    iconTheme.name = "Adwaita";
    colorScheme = "dark";
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };
}
