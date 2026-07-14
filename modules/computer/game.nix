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
  environment.systemPackages = with pkgs; [mangohud lutris];
}
