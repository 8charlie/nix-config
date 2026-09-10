{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # ghostty proper is linux-only in nixpkgs; darwin uses the signed upstream build
    # Neovim comes from modules/common/neovim.nix (wrapped, with viAlias).
    _7zz
    ghostty-bin
    gnumake
    mpv
    vesktop
    vscode
    uv
    yazi
  ];
}
