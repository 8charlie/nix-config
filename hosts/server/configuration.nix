{lib, ...}: {
  imports = lib.collectNix ../../modules/server;

  documentation.man.generateCaches = false; # very slow rebuild times if enabled
  system.stateVersion = "25.11";
}
