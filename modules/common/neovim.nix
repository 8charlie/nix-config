{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # nix-darwin has no programs.neovim, so wrap the package directly instead —
    # this is what the NixOS module does under the hood, and it works on both
    (neovim.override {viAlias = true;})

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

  # defaultEditor = true, spelled portably
  environment.variables.EDITOR = "nvim";
}
