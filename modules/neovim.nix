{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # for lazyvim
    nodejs

    # for telescope
    ripgrep
    fd
    fzf

    luarocks # some plugins need this
    tree-sitter

    # language Servers
    lua-language-server
    nil # nix language server
    cargo # needed for nil
    clang-tools # needed for clangd
    unzip # needed for mason

    # formatters
    alejandra
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
  };
}
