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

  programs.yazi.enable = true;
  home.packages = with pkgs; [
    bluez
    bluez-tools
    efibootmgr
    baobab
    gparted
    nix-search-cli
    magic-wormhole
    p7zip

    ghostty
    tmux
    htop
    librewolf
    brave
    chromium
    vesktop
    zathura
    freetube
    spotify
    xfce.thunar
    steam

    gcc
    git
    gtk3
    gtk4
    xwayland-satellite # necessary for xwayland to work on niri
  ];
  services.syncthing.enable = true;

  # makes the symlinks in ./config to ~/.config
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  home.stateVersion = "25.11";
}
