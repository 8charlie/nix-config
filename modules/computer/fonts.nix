{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      cascadia-code
      dejavu_fonts
      fira-code
      fira-code-symbols
      font-awesome
      ibm-plex
      liberation_ttf
      material-symbols
      nerd-fonts.blex-mono
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      terminus_font
    ];
    #    fontconfig = {
    #      enable = true;
    #      defaultFonts = {
    #        serif = ["Noto Serif" "DejaVu Serif"];
    #        sansSerif = ["Noto Sans" "DejaVu Sans"];
    #        monospace = ["JetBrainsMono Nerd Font" "Fira Code" "DejaVu Sans Mono"];
    #        emoji = ["Noto Color Emoji"];
    #      };
    #    };
  };
}
