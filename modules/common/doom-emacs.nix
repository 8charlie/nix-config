{
  lib,
  pkgs,
  ...
}: let
  # pgtk is the native Wayland build (niri/hyprland); it has no macOS backend,
  # so darwin takes the default build, which is the Cocoa one there
  baseEmacs =
    if pkgs.stdenv.isDarwin
    then pkgs.emacs
    else pkgs.emacs-pgtk;

  # Doom installs its own packages with straight.el, but vterm needs a compiled
  # module, so that one comes from nixpkgs prebuilt. So do the tree-sitter
  # grammars for the languages with +tree-sitter in dots/doom/init.el: built
  # against the same tree-sitter as Emacs, and the wrapper puts them on
  # `treesit-extra-load-path', so Doom never offers to compile its own.
  emacs = (pkgs.emacsPackagesFor baseEmacs).emacsWithPackages (epkgs: [
    epkgs.vterm
    (epkgs.treesit-grammars.with-grammars (g: [
      g.tree-sitter-c
      g.tree-sitter-cpp
      g.tree-sitter-python
      g.tree-sitter-rust
    ]))
  ]);

  # Doom itself lives outside the store in ~/.config/emacs, where it keeps its
  # packages and caches. This puts `doom` on PATH for every shell and clones
  # Doom on first use, the same way dots/nvim/init.lua bootstraps lazy.nvim.
  doom = pkgs.writeShellScriptBin "doom" ''
    emacsdir="''${EMACSDIR:-''${XDG_CONFIG_HOME:-$HOME/.config}/emacs}"
    if [ ! -x "$emacsdir/bin/doom" ]; then
      echo "doom: cloning Doom Emacs into $emacsdir" >&2
      ${pkgs.git}/bin/git clone --depth 1 https://github.com/doomemacs/core "$emacsdir" || exit 1
    fi
    exec "$emacsdir/bin/doom" "$@"
  '';
in {
  environment.systemPackages = with pkgs;
    [
      emacs
      doom

      # required by Doom
      git
      ripgrep
      fd

      # markdown compiler for Doom's markdown-preview (SPC m p)
      pandoc

      # spell checker for Doom's :checkers spell; en covers en_GB
      (aspellWithDicts (dicts: [dicts.en]))

      # grammar checker for Doom's :checkers grammar (`M-x langtool-check')
      languagetool

      # :tools direnv loads each project's .envrc into its buffers. NixOS also
      # gets this from modules/nixos/direnv.nix; darwin has nothing else.
      direnv
    ]
    # dired wants GNU ls, which Doom looks for as `gls`
    ++ lib.optionals stdenv.isDarwin [coreutils-prefixed];

  fonts.packages = with pkgs.nerd-fonts; [
    # doom-font and doom-variable-pitch-font in dots/doom/config.el
    iosevka
    (pkgs.iosevka-bin.override {variant = "Aile";})
    # ghostty's font (dots/ghostty/config); darwin has no fonts.nix to get it from
    blex-mono
    # the icon font Doom's modeline and dashboard draw with (nerd-icons)
    symbols-only
  ];
}
