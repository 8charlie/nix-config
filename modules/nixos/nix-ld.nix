{pkgs, ...}: {
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    icu
    libGL
    libxkbcommon
    libX11
    libXcursor
    libXrandr
    libXi
    qt6.qtbase
  ];
}
