{ config, pkgs, lib, ...}:

{
  home.packages = with pkgs; [
    # Tools required for Telescope
    ripgrep
    fd
    fzf

    # Language Servers
    lua-language-server
    nil # nix language server
    nixpkgs-fmt # nix formatter
	clang-tools # needed for clangd
	cargo # needed for nil

    # Needed for lazy.nvim
    nodejs

  ];

  programs.neovim = {
    enable = true;
    #viAlias = true;
    #vimAlias = true;
  };

}
