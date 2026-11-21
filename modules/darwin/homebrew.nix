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
      "hammerspoon"
      "raycast"
      "spotify"
      "sioyek"
      # reference manager; add the Better BibTeX plugin from its add-ons menu
      "zotero"
    ];
  };
}
