{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
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
      (discord.override {
        withOpenASAR = true; # can do this here too
        withVencord = true;
      })
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
      matugen
      nautilus
      (p7zip.override {enableUnfree = true;})
      protonup-qt
      protonvpn-gui
      qbittorrent
      sbctl
      slurp
      spotify
      steam
      #vesktop
      wireshark
      wl-clipboard
      wlr-randr
      wmenu
      xwayland-satellite # necessary for xwayland on niri
      zathura
    ]
    ++ [
      inputs.caelestia-shell.packages.${pkgs.system}.with-cli
    ];
}
