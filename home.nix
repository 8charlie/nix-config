{
  config,
  lib,
  pkgs,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/.dotfiles/dots";
  #createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
  # Standard .config/directory
  #configs = ["DankMaterialShell" "fish" "ghostty" "hypr" "niri" "nvim" "tmux" "zathura"];
in {
  imports = lib.collectNix ./modules/computer/home;

  #xdg.configFile = lib.genAttrs configs (name: {
  #  source = createSymlink "${dotfiles}/${name}";
  #  recursive = true;
  #});

  xdg.configFile =
    lib.mapAttrs
    (name: _: {source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";})
    (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./dots));

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    enableBashIntegration = true;
  };

  home = {
    username = "charlie";
    homeDirectory = "/home/charlie";
    stateVersion = "25.11";
  };
}
