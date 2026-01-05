{inputs, ...}: {
  services.displayManager.ly.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };
  imports = [
    inputs.dms.nixosModules.dankMaterialShell
  ];

  programs.dankMaterialShell.enable = true;
  programs.niri.enable = true;
  programs.hyprland.enable = true;
}
