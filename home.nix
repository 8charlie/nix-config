{
  config,
  lib,
  pkgs,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/.dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard .config/directory
  configs = {
    nvim = "nvim";
    fish = "fish";
    ghostty = "ghostty";
    hypr = "hypr";
    mango = "mango";
    niri = "niri";
    tmux = "tmux";
    zathura = "zathura";
  };
in {
  home.username = "charlie";
  home.homeDirectory = "/home/charlie";

  imports = lib.collectNix ./modules/home;

  # makes the symlinks in ./config to ~/.config
  xdg.configFile =
    builtins.mapAttrs (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  home.stateVersion = "25.11";
}
