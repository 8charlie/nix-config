{
  # lets home-manager manage its own paths (man pages, `home-manager` cli)
  programs.home-manager.enable = true;

  # never change this; it pins backwards-compat behaviour, not the hm version
  home.stateVersion = "26.05";
}
