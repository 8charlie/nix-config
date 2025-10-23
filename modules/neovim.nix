{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Tools required for Telescope
    ripgrep
    fd
    fzf

    # Language Servers
    lua-language-server
    nil # nix language server
    cargo # needed for nil
    nixpkgs-fmt
    clang-tools # needed for clangd

    # Needed for lazy.nvim
    nodejs

  ];

  programs.neovim = {
    enable = true;
    #viAlias = true;
    #vimAlias = true;
  };

}
