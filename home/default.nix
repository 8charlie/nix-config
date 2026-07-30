{
  # imports are listed explicitly rather than via lib.collectNix: home-manager
  # passes its own extended lib (lib.hm.*) to these modules, and overriding it
  # through extraSpecialArgs to get collectNix would break hm's internals.
  imports = [./dots.nix ./firefox.nix];

  # lets home-manager manage its own paths (man pages, `home-manager` cli)
  programs.home-manager.enable = true;

  # never change this; it pins backwards-compat behaviour, not the hm version
  home.stateVersion = "26.05";
}
