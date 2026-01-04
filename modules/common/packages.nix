{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bat
    cargo
    clang-tools
    fd
    ffmpeg
    fzf
    git
    gnumake
    htop
    librewolf
    magic-wormhole
    mpv
    nix-search-cli
    nodejs
    python3
    ripgrep
    rustc
    tealdeer
    tmux
    unzip
  ];
}
