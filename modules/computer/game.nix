{pkgs, ...}: {
  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
    protontricks.enable = true;
  };
  programs.gamescope = {
    enable = true;
  };
  programs.gamemode.enable = true;
  environment.systemPackages = with pkgs; [mangohud winetricks];
}
