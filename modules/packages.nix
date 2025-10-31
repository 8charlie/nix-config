{pkgs, ...}: {
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
    yazi
    zathura
  ];
}
