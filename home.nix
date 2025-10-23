{ config, inputs, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  # Standard .config/directory
  configs = {
    nvim = "nvim";
    fish = "fish";
    ghostty = "ghostty";
    niri = "niri";
    tmux = "tmux";
    zathura = "zathura";
  };

in {
  home.username = "charlie";
  home.homeDirectory = "/home/charlie";

  imports = [
    ./modules/cursor.nix
    ./modules/display.nix
    ./modules/fonts.nix
    ./modules/neovim.nix
  ];

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  programs.yazi.enable = true;
  home.packages = with pkgs; [
    ghostty
    htop
    librewolf
    tmux
    vesktop
    zathura

    gcc
    git
    p7zip
  ];

  home.stateVersion = "25.11";
}
