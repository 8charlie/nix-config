{
  imports = [
    ./graphics.nix
    ./hardware.nix
  ];

  programs.helium-browser = {
    enable = true;
    makeDefault = true;
  };
}
