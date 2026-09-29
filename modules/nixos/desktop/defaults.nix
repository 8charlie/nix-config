{
  pkgs,
  ...
}: {
  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";

    XDG_DOWNLOAD_DIR = "$HOME/Downloads";
    XDG_DOCUMENTS_DIR = "$HOME/Documents";
    XDG_PICTURES_DIR = "$HOME/Pictures";

    GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";

    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gnome xdg-desktop-portal-gtk];
      config = {
        common = {
          default = ["gtk"];
        };
      };
    };
    # set default apps
    mime.defaultApplications = {
      "inode/directory" = "nautilus.desktop";
      "image/png" = "feh.desktop";
      "image/jpeg" = "feh.desktop";
      "text/plain" = "nvim.desktop";
      "text/html" = "firefox.desktop";
      "video/mp4" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };
}
