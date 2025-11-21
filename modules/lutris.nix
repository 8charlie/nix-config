{pkgs, ...}: {
  home.packages = with pkgs; [
    protonup-ng
    lutris
    bottles
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
