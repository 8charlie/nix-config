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
      enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    grim
    qview
    wl-clipboard
    wlr-randr
    wmenu
    xwayland-satellite
  ];
}
