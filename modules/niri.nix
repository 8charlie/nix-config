{ config, pkgs, lib, inputs, ... }: {
  home.packages = [ pkgs.niri pkgs.wofi pkgs.wl-clipboard ];
}
