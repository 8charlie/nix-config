{pkgs, ...}: {
  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
    protontricks.enable = true;
  };
  # bottles only finds runners in its own runners dir, never Steam's, so
  # link the same GE-Proton in. unversioned name so bottles that use it
  # survive proton-ge-bin updates.
  home-manager.users.charlie = {
    xdg.dataFile."bottles/runners/GE-Proton".source = "${pkgs.proton-ge-bin.steamcompattool}";
  };
  programs.gamescope = {
    enable = true;
  };
  programs.gamemode.enable = true;
  environment.systemPackages = with pkgs; [
    mangohud
    winetricks
    # for bloodborne
    shadps4
    shadps4-qtlauncher
  ];
}
