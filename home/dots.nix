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

  entries =
    lib.filterAttrs
    (name: _: !(builtins.elem name excluded))
    (builtins.readDir ../dots);

  linkTo = name: {source = config.lib.file.mkOutOfStoreSymlink "${dotsPath}/${name}";};

  # subdirs land in ~/.config; loose files at the top of dots/ land in ~
  dirs = lib.filterAttrs (_: type: type == "directory") entries;
  files = lib.filterAttrs (_: type: type == "regular") entries;
in {
  xdg.configFile = lib.mapAttrs (name: _: linkTo name) dirs;
  home.file = lib.mapAttrs (name: _: linkTo name) files;
}
