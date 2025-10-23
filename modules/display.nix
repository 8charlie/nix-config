{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [ niri wofi wl-clipboard ];

  imports = [ inputs.dankMaterialShell.homeModules.dankMaterialShell.default ];

  programs.dankMaterialShell.enable = true;
}
