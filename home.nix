{
  config,
  inputs,
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

  home.packages = with pkgs; [
    baobab
    bluetui
    bluez
    bluez-tools
    brave
    chromium
    efibootmgr
    fd
    feh
    freetube
    gcc
    ghostty
    git
    gparted
    gtk3
    gtk4
    helix
    htop
    librewolf
    magic-wormhole
    mpv
    nix-search-cli
    p7zip
    sbctl
    spotify
    steam
    tmux
    vesktop
    xfce.thunar
    wl-clipboard
    xwayland-satellite # necessary for xwayland to work on niri
    zathura
  ];
  programs.yazi.enable = true;
  services.syncthing.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "thunar.desktop";
      "image/png" = "feh.desktop";
      "image/jpeg" = "feh.desktop";
      "text/plain" = "nvim.desktop";
      "text/html" = "librewolf.desktop";
      "video/mp4" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
    };
  };
  # makes the symlinks in ./config to ~/.config
  xdg.configFile =
    builtins.mapAttrs (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  home.stateVersion = "25.11";
}
