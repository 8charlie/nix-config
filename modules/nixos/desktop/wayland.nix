{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    grim
    qview
    wl-clipboard
    wlr-randr
    wmenu
    xwayland-satellite
  ];
}
