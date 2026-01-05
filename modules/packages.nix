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
      bat
      bluetui
      bluez
      bluez-tools
      bottles
      brave
      cargo
      chromium
      clang-tools
      clippy
      (discord.override {
        withOpenASAR = true; # can do this here too
        withVencord = true;
      })
      drawing
      efibootmgr
      fd
      feh
      ffmpeg
      firefox
      freetube
      fzf
      gamescope
      gcc
      ghostty
      gimp
      git
      gnumake
      gparted
      grim
      gtk3
      gtk4
      htop
      librewolf
      lutris
      magic-wormhole
      man-pages
      matugen
      mpv
      nautilus
      nix-search-cli
      nodejs
      (p7zip.override {enableUnfree = true;})
      protonup-qt
      protonvpn-gui
      python3
      qbittorrent
      ripgrep
      rustc
      sbctl
      slurp
      spotify
      steam
      tealdeer
      tmux
      unzip
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
