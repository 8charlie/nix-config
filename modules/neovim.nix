{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [

    # for lazyvim
    nodejs

    # for telescope
    ripgrep
    fd
    fzf

    # language Servers
    lua-language-server
    nil # nix language server
    cargo # needed for nil
    clang-tools # needed for clangd
    unzip # needed for mason

    # formatters
    nixpkgs-fmt
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

}
