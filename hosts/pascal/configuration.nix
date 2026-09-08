{lib, ...}: {
  imports = lib.collectNix ../../modules/computer;

  # The Windows reserved partition advertises the same filesystem UUID as root.
  # Use root's unique partition UUID so boot always selects the correct device.
  fileSystems."/".device = lib.mkForce "/dev/disk/by-partuuid/19f7fe31-dd12-46f5-a151-55a07237ab58";

  system.stateVersion = "25.11";
}
