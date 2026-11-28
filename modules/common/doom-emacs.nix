{
  inputs,
  lib,
  pkgs,
  ...
}: let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
  };

  # pgtk is the native Wayland build (niri/hyprland); it has no macOS backend,
  # so darwin takes the default build, which is the Cocoa one there
  baseEmacs =
    if pkgs.stdenv.isDarwin
    then pkgs.emacs
    else pkgs.emacs-pgtk;

  # Build ghostel's native libghostty module from source (matching Doom's :term
  # ghostel 0.60.0 pin) rather than letting `M-x ghostel-download-module' fetch
  # an unverified binary from GitHub Releases. nixos-26.05 lacks Zig 0.17, so
  # the Zig toolchain for this module comes from nixpkgs-unstable.
  ghostelSrc = pkgs.applyPatches {
    name = "ghostel-source";
    src = pkgs.fetchFromGitHub {
      owner = "dakra";
      repo = "ghostel";
      rev = "a63db707e0d71e49eb4de95b198e288788eb92f8";
      hash = "sha256-w78B09HvNHRHHd06sFxuBDEuuHxLXqEhCBCVydgwaHc=";
    };
    # build.zig checks for exact 0.17.0, while nixpkgs-unstable ships 0.17.1
    postPatch = ''
      substituteInPlace build.zig \
        --replace-fail 'builtin.zig_version.order(required_zig) != .eq' \
                       'builtin.zig_version.major != 0 or builtin.zig_version.minor != 17'
    '';
  };

  ghostelModule = unstable.stdenv.mkDerivation (finalAttrs: {
    pname = "ghostel-module";
    version = "0.60.0";
    src = ghostelSrc;

    zigDeps = unstable.zig_0_17.fetchDeps {
      inherit (finalAttrs) src pname version;
      fetchAll = true;
      hash = "sha256-Kt3r1B/5kgjMO89gih/87oEtuWmby9NB6oQp5t0vUYw=";
    };

    nativeBuildInputs =
      [unstable.zig_0_17]
      ++ lib.optionals unstable.stdenv.hostPlatform.isDarwin [unstable.xcbuild];

    env.EMACS_INCLUDE_DIR = "${baseEmacs}/include";

    dontSetZigDefaultFlags = true;
    doCheck = true;
    zigCheckFlags = [
      "-Dcpu=baseline"
      "-Doptimize=ReleaseFast"
    ];
    zigBuildFlags = finalAttrs.zigCheckFlags;

    postConfigure = ''
      cp -rLT ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
      chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
    '';

    strictDeps = true;
    __structuredAttrs = true;
  });

  libExt = pkgs.stdenv.hostPlatform.extensions.sharedLibrary;

  # Doom installs its own packages with straight.el, but the tree-sitter
  # grammars for the languages with +tree-sitter in dots/doom/init.el come from
  # nixpkgs prebuilt: built against the same tree-sitter as Emacs, and the
  # wrapper puts them on `treesit-extra-load-path', so Doom never offers to
  # compile its own. ghostel's native module is built above and linked into
  # ~/.local/share/ghostel/ (where `ghostel-module-directory' looks).
  emacs = (pkgs.emacsPackagesFor baseEmacs).emacsWithPackages (epkgs: [
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
    # doom-font (BlexMono, also ghostty's) and doom-variable-pitch-font (IBM
    # Plex Sans) in dots/doom/config.el; darwin has no fonts.nix to get them from
    blex-mono
    pkgs.ibm-plex
    # the icon font Doom's modeline and dashboard draw with (nerd-icons)
    symbols-only
  ];

  home-manager.users.charlie.xdg.dataFile = {
    "ghostel/ghostel-module${libExt}".source = "${ghostelModule}/ghostel-module${libExt}";
    "ghostel/ghostel-module.version".source = "${ghostelModule}/ghostel-module.version";
  };
}
