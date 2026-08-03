{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.helium-browser;
  pname = "helium";
  version = "0.15.1.1";

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-qz3w+nnvBgkpHT3E34dv4DvFuYlyzTAyg9tPYJFWs3o=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };

  helium = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    nativeBuildInputs = [pkgs.makeWrapper];
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/helium.desktop \
        $out/share/applications/helium.desktop
      install -m 444 -D ${appimageContents}/helium.png \
        $out/share/icons/hicolor/256x256/apps/helium.png

      # Prefer native Wayland under Niri, while retaining an X11 fallback.
      mv $out/bin/helium $out/bin/.helium-unwrapped
      makeWrapper $out/bin/.helium-unwrapped $out/bin/helium \
        --add-flags "--ozone-platform-hint=auto"
    '';

    meta = {
      description = "Privacy-focused Chromium-based web browser";
      homepage = "https://helium.computer";
      license = with lib.licenses; [gpl3Only bsd3];
      mainProgram = "helium";
      platforms = ["x86_64-linux"];
    };
  };
in {
  options.programs.helium-browser = {
    enable = lib.mkEnableOption "Helium Browser";

    package = lib.mkOption {
      type = lib.types.package;
      default = helium;
      defaultText = lib.literalExpression "the pinned official Helium AppImage";
      description = "Helium package to install.";
    };

    makeDefault = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use Helium for web links and as the browser started by Niri.";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages = [cfg.package];
    }

    (lib.mkIf cfg.makeDefault {
      environment.sessionVariables.BROWSER = "helium";

      xdg.mime.defaultApplications = {
        "text/html" = "helium.desktop";
        "x-scheme-handler/http" = "helium.desktop";
        "x-scheme-handler/https" = "helium.desktop";
      };
    })
  ]);
}
