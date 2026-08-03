{lib, ...}: {
  imports = lib.collectNix ../../modules/computer;

  system.stateVersion = "25.11";
}
