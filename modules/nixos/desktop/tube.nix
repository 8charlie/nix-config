{inputs, ...}: {
  # tube (~/Documents/work/tube): rofi front-end for YouTube, playing in the
  # mpv set up in ./mpv.nix. Opened with Mod+Y in niri.
  home-manager.users.charlie = {
    imports = [inputs.tube.homeManagerModules.default];
    programs.tube.enable = true;
  };
}
