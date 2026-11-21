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
    # removes any formula/cask not listed here, so this list is the whole truth
    # ("zap" would also delete their app data)
    onActivation.cleanup = "uninstall";
    brews = [
    ];
    casks = [
      #      "aerospace"
      "battery"
      # no firefox cask: home/firefox.nix installs it, with the policies applied
      "hammerspoon"
      "raycast"
      "spotify"
      "sioyek"
      # reference manager; add the Better BibTeX plugin from its add-ons menu
      "zotero"
    ];
  };
}
