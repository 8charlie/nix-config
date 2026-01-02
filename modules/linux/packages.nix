{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    alsa-utils
    baobab
    bluetui
    bluez
    bluez-tools
    bottles
    brave
    chromium
    clippy
    drawing
    efibootmgr
    feh
    firefox
    freetube
    gamescope
    gcc
    ghostty
    gimp
    gparted
    grim
    gtk3
    gtk4
    librewolf
    lutris
    man-pages
    nautilus
    (p7zip.override {enableUnfree = true;})
    protonup-qt
    protonvpn-gui
    qbittorrent
    sbctl
    slurp
    spotify
    steam
    vesktop
    wireshark
    wl-clipboard
    wlr-randr
    wmenu
    xwayland-satellite # necessary for xwayland on niri
    zathura
    #yazi
  ];
}
