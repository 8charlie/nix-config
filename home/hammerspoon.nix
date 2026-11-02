{
  inputs,
  lib,
  pkgs,
  ...
}: let
  # only the cli of InstantSpaceSwitcher, which changes Space with a synthetic
  # trackpad swipe too fast to animate. built here because upstream's app is
  # unsigned and its menu bar half would only duplicate hammerspoon's hotkeys
  isscli = pkgs.stdenv.mkDerivation {
    pname = "isscli";
    version = inputs.instant-space-switcher.shortRev;
    src = inputs.instant-space-switcher;
    buildPhase = ''
      $CC -O2 -o ISSCli \
        Sources/ISSCli/main.c Sources/ISS/ISS.c Sources/ISS/event_serialize.c \
        -framework ApplicationServices -framework CoreFoundation -framework IOKit
    '';
    installPhase = ''
      install -Dm755 ISSCli $out/bin/ISSCli
    '';
  };
in
  lib.mkIf pkgs.stdenv.isDarwin {
    # ~/.config/hammerspoon is a live symlink into dots/, so nothing pinned can
    # be linked inside it; init.lua reaches for these in ~/.local/share instead
    xdg.dataFile = {
      "hammerspoon/Spoons/PaperWM.spoon".source = inputs.paperwm-spoon;
      "hammerspoon/ISSCli".source = "${isscli}/bin/ISSCli";
    };
  }
