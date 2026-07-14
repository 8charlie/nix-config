{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
      protontricks.enable = true;
    };
    gamescope.enable = true;
    gamemode.enable = true;
  };
  environment.SystemPackages = with pkgs; [mangohud lutris];
}
