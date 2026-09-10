{
  config,
  inputs,
  ...
}: {
  imports = [inputs.nix-homebrew.darwinModules.nix-homebrew];

  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
    enableRosetta = false;
  };

  homebrew = {
    enable = true;
    brews = [
    ];
    casks = [
      #      "aerospace"
      "battery"
      "firefox"
      "raycast"
      "spotify"
      "helium-browser"
      "sioyek"
    ];
  };
}
