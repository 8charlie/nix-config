{
  config,
  lib,
  pkgs,
  ...
}: let
  dotsPath = "${config.home.homeDirectory}/.dotfiles/dots";

  # dirs that only make sense on one platform; everything else is linked on both
  linuxOnly = ["DankMaterialShell" "i3" "niri" "sway"];
  darwinOnly = ["aerospace"];
  excluded =
    if pkgs.stdenv.isDarwin
    then linuxOnly
    else darwinOnly;

  dirs =
    lib.filterAttrs
    (name: type: type == "directory" && !(builtins.elem name excluded))
    (builtins.readDir ../dots);
in {
  xdg.configFile =
    lib.mapAttrs
    (name: _: {source = config.lib.file.mkOutOfStoreSymlink "${dotsPath}/${name}";})
    dirs;
}
