{inputs, ...}: {
  services.displayManager.ly.enable = true;
  programs.niri.enable = true;
  programs.hyprland.enable = true;

  imports = [
    inputs.dms.nixosModules.dankMaterialShell
  ];
  programs.dankMaterialShell.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };
  # so that portal definitions and de provided configurations get linked?
  environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

  programs.ssh.enableAskPassword = false;
  services.gnome.gnome-keyring.enable = false;
}
