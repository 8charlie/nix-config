{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # python
    basedpyright
    ruff

    # nix
    nil
    alejandra

    # rust
    cargo
    rust-analyzer
    rustfmt

    # c
    clang-tools

    # haskell
    haskell-language-server
    ormolu

    # lua
    lua-language-server

    # for neovim plugins
    nodejs
    luarocks
    tree-sitter
    ripgrep
    fd
    fzf
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };
}
