{
  imports = [
    ./graphics.nix
    ./hardware.nix
  ];

  programs.helium-browser = {
    enable = true;
    makeDefault = true;
  };
  systemd.services.NetworkManager-wait-online.enable = false;
}
