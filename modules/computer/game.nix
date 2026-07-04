{pkgs, ...}: {
  environment.sessionVariables = {
    # force xwayland for steam
    #SDL_VIDEODRIVER = "x11";
  };
  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
    protontricks.enable = true;
  };
  programs.gamescope = {
    enable = true;
  };
  programs.gamemode.enable = true;
}
