{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # language Servers
    lua-language-server
    nil # nix language server
    cargo # for nil
    clang-tools # for clangd
    rust-analyzer
    haskell-language-server
    pyright

    # formatters
    alejandra # for nix
    rustfmt
    ormolu # for haskell

    # for lazyvim
    nodejs

    # for telescope
    ripgrep
    fd
    fzf

    # required by some plugins
    luarocks
    tree-sitter
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };
}
