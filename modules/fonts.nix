{ pkgs, inputs, ... }: {

  home.packages = with pkgs; [
    cascadia-code
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    dejavu_fonts
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Noto Serif" "DejaVu Serif" ];
      sansSerif = [ "Noto Sans" "DejaVu Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" "Fira Code" "DejaVu Sans Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
