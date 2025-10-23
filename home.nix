{ config, pkgs, inputs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  # Standard .config/directory
  configs = {
    nvim = "nvim";
    ghostty = "ghostty";
    hypr = "hypr";
    niri = "niri";
    tmux = "tmux";
    zathura = "zathura";
  };

in {
  home.username = "charlie";
  home.homeDirectory = "/home/charlie";

  imports = [ ./modules/display.nix ./modules/fonts.nix ./modules/neovim.nix ];

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  programs.yazi.enable = true;
  home.packages = with pkgs; [
    ghostty
    tmux
    librewolf
    zathura
    vesktop

    p7zip
    htop
    git
    gcc
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };

  home.stateVersion = "25.11";
}
