{pkgs, ...}: {
  home.packages = with pkgs; [
    lutris
    bottles
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
