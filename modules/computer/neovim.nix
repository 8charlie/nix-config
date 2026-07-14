{pkgs, ...}: {
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
    haskell-language-server

    # formatters
    alejandra
    rustfmt
    ormolu
  ];

  programs.neovim = {
    enable = true;
  };
}
