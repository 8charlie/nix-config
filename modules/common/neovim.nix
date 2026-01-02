{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
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
    cargo # for nil
    clang-tools # for clangd
    rust-analyzer

    # formatters
    alejandra
    rustfmt
  ];

  #  programs.neovim = {
  #    enable = true;
  #    vimAlias = true;
  #  };
}
