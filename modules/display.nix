{
  pkgs,
  inputs,
  ...
}: {
  # niri pkg is in configuration.nix

  imports = [inputs.dankMaterialShell.homeModules.dankMaterialShell.default];
  programs.dankMaterialShell.enable = true;
}
