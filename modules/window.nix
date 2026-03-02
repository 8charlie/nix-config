{inputs, ...}: {
  services.displayManager.ly.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.niri.enable = true;
  programs.hyprland.enable = true;

  imports = [
    inputs.dms.nixosModules.dank-material-shell
  ];
  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = false;
  };

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };
  # so that portal definitions and de provided configurations get linked?
  environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

  services.dbus.enable = true;

  programs.ssh.enableAskPassword = false;
  services.gnome.gnome-keyring.enable = false;
}
