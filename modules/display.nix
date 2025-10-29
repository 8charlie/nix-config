{ pkgs, inputs, ... }: {

  # niri pkg is in configuration.nix
  home.packages = with pkgs; [ wofi wl-clipboard ];

  imports = [ inputs.dankMaterialShell.homeModules.dankMaterialShell.default ];

  programs.dankMaterialShell.enable = true;
}
