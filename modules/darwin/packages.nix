{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # ghostty proper is linux-only in nixpkgs; darwin uses the signed upstream build
    # Neovim comes from modules/common/neovim.nix (wrapped, with viAlias).
    _7zz
    ghostty-bin
    gnumake
    mpv
    tmux
    vesktop
    # VS Code 1.144 ships its bundled rg as
    # node_modules.asar.unpacked/@vscode/ripgrep-universal/bin/<system>/rg, but
    # nixos-26.05's vscode postPatch still chmods the old @vscode/ripgrep path
    # and fails. Point it at the new location (as nixos-unstable already
    # does). m5 is aarch64-darwin only. Drop once the fix is backported to 26.05.
    (vscode.overrideAttrs (old: {
      postPatch =
        builtins.replaceStrings
        ["Contents/Resources/app/node_modules/@vscode/ripgrep/bin/rg"]
        ["Contents/Resources/app/node_modules.asar.unpacked/@vscode/ripgrep-universal/bin/darwin-arm64/rg"]
        old.postPatch;
    }))
    uv
    yazi
  ];
}
