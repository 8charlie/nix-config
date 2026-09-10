{
  imports = [./dms.nix ./niri.nix];

  services = {
    displayManager.ly.enable = false;
    displayManager.dms-greeter = {
      enable = true;
      compositor = {
        name = "niri"; # Required. Can be also "hyprland" or "sway"
      };
      # Sync your user's DankMaterialShell theme with the greeter. You'll probably want this
      configHome = "/home/charlie";
      # Custom config files for non-standard config locations
      configFiles = [
        "/home/charlie/.config/DankMaterialShell/settings.json"
      ];
      # Save the logs to a file
      logs = {
        save = true;
        path = "/tmp/dms-greeter.log";
      };
    };
  };
}
