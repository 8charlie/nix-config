{ config, pkgs, lib, inputs, ... }: {
  home.packages = [
    inputs.caelestia-shell.packages.${pkgs.system}.caelestia-shell
    pkgs.hyprland
    pkgs.wofi
    pkgs.wl-clipboard
    pkgs.hyprlandPlugins.hyprscrolling
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;

    # CRITICAL: Tell home-manager to NOT generate any config files
    # We're using our own dotfiles instead
    extraConfig = ""; # Empty string prevents auto-generation

    # Disable systemd integration which tries to create configs
    systemd.enable = false;
  };
}
