{lib}: let
  inherit (builtins) readDir attrNames filter map;
  inherit (lib) hasSuffix;
in {
  collectNix = dir: let
    entries = readDir dir;
    nixFiles = filter (name: hasSuffix ".nix" name) (attrNames entries);
  in
    map (name: dir + "/${name}") nixFiles;

  remove = toRemove: list:
    filter (item: item != toRemove) list;
}
