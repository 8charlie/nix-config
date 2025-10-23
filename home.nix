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

  imports = [
    ./modules/neovim.nix
    ./modules/hyprland.nix
    #    ./modules/niri.nix

    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
  ];

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  programs.dankMaterialShell.enable = true;
  programs.yazi.enable = true;
  home.packages = with pkgs; [
    niri
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

  home.stateVersion = "25.05";
}
