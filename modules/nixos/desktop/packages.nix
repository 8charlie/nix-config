{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    alsa-utils
    appimage-run
    baobab
    bat
    bluetui
    bluez
    bluez-tools
    (bottles.override {
      removeWarningPopup = true;
      # bottles thinks it is offline, so first-run setup can't download a
      # runner: usebottles.com's Cloudflare rejects pycurl's default
      # User-Agent (403, error 1010) and ping.usebottles.com is down (522).
      # Send the curl UA bottles already fakes elsewhere and probe the
      # component repo instead. Drop once upstream is fixed.
      bottles-unwrapped = bottles-unwrapped.overrideAttrs (old: {
        postPatch =
          (old.postPatch or "")
          + ''
            substituteInPlace \
              bottles/backend/utils/connection.py \
              bottles/backend/managers/repository.py \
              bottles/backend/managers/installer.py \
              bottles/backend/repos/repo.py \
              --replace-fail 'c = pycurl.Curl()' 'c = pycurl.Curl(); c.setopt(pycurl.USERAGENT, "curl/7.79.1")'
            substituteInPlace bottles/backend/utils/connection.py \
              --replace-fail "https://ping.usebottles.com" "https://proxy.usebottles.com/repo/components/index.yml"
          '';
      });
    })
    brave
    cargo
    chromium
    clang-tools
    dnsutils
    efibootmgr
    fd
    feh
    ffmpeg
    flameshot
    freetube
    fuse
    fzf
    gcc
    ghostty
    git
    gnome-system-monitor
    gnumake
    gparted
    gtk3
    gtk4
    htop
    librewolf
    lutris
    man-pages
    mpv
    nautilus
    #nextcloud-client
    nicotine-plus
    nix-search-cli
    nodejs
    (p7zip.override {enableUnfree = true;})
    positron-bin
    proton-vpn
    python3
    qbittorrent
    ripgrep
    rofi
    rustc
    sioyek
    spotify
    tmux
    unzip
    vesktop
    vim
    (pkgs.vscode.fhsWithPackages (ps: with ps; [zlib openssl.dev pkg-config]))
    wget
    yazi
    zathura
  ];
}
