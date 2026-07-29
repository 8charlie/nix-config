{
  services.resolved.enable = true;
  networking.networkmanager.enable = true;
  # for faster boot times
  systemd.services.NetworkManager-wait-online.enable = false;
}
