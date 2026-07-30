{
  config,
  lib,
  pkgs,
  ...
}: let
  # Out-of-store symlinks: ~/.config/<name> points straight at the working tree,
  # so edits are live (no rebuild) and apps that write their own config
  # (DankMaterialShell, matugen, lazy.nvim, fish) can still do so. This assumes
  # the repo is checked out at ~/.dotfiles on every host.
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
