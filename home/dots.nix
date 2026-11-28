{
  config,
  lib,
  pkgs,
  ...
}: let
  dotsPath = "${config.home.homeDirectory}/.dotfiles/dots";

  # dirs that only make sense on one platform; everything else is linked on both
  linuxOnly = ["hypr" "i3" "niri" "sway"];
  darwinOnly = ["aerospace" "hammerspoon"];
  excluded =
    if pkgs.stdenv.isDarwin
    then linuxOnly
    else darwinOnly;

  # apps that also write their own state into their config dir (fish keeps
  # fish_variables there): link these dirs' entries one by one instead, so
  # ~/.config/<name> is a real dir and that state lands outside the repo
  linkEntries = ["fish"];

  entries =
    lib.filterAttrs
    (name: _: !(builtins.elem name excluded))
    (builtins.readDir ../dots);

  linkTo = name: {source = config.lib.file.mkOutOfStoreSymlink "${dotsPath}/${name}";};

  # subdirs land in ~/.config; loose files at the top of dots/ land in ~
  dirs = lib.filterAttrs (_: type: type == "directory") entries;
  files = lib.filterAttrs (_: type: type == "regular") entries;

  linkDir = name: _:
    if builtins.elem name linkEntries
    then
      lib.mapAttrs'
      (entry: _: lib.nameValuePair "${name}/${entry}" (linkTo "${name}/${entry}"))
      (builtins.readDir (../dots + "/${name}"))
    else {${name} = linkTo name;};
in {
  xdg.configFile = lib.concatMapAttrs linkDir dirs;
  home.file = lib.mapAttrs (name: _: linkTo name) files;

  # A dir newly in linkEntries is still a single link into dots/ from the
  # previous generation. Home-manager would see the files behind it as
  # conflicts and, with backupFileExtension set, rename them inside the repo
  # and leave self-referencing links, so swap that old link for a real dir
  # before it checks.
  home.activation.unlinkWholeDirs = lib.hm.dag.entryBefore ["checkLinkTargets"] (
    lib.concatMapStrings (name: ''
      dir=${lib.escapeShellArg "${config.xdg.configHome}/${name}"}
      if [[ -L "$dir" && "$(readlink "$dir")" == ${builtins.storeDir}/*-home-manager-files/* ]]; then
        run rm $VERBOSE_ARG "$dir"
        run mkdir $VERBOSE_ARG "$dir"
      fi
    '')
    linkEntries
  );
}
