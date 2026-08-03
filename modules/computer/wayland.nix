{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.dms.nixosModules.dank-material-shell
  ];
  programs = {
    dank-material-shell = {
      enable = true;
      enableSystemMonitoring = false;
    };
    niri = {
      enable = true;
    };
    hyprland = {
      enable = false;
    };
  };
  environment.systemPackages = with pkgs; [
    wl-clipboard
    wlr-randr
    wmenu
    xwayland-satellite
  ];
}
