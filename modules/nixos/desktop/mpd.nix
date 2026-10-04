{pkgs, ...}: {
  environment.systemPackages = [pkgs.rmpc];

  # user service rather than system so mpd can reach the session's pipewire
  home-manager.users.charlie = {config, ...}: {
    services = {
      mpd = {
        enable = true;
        musicDirectory = "${config.home.homeDirectory}/Music";
        extraConfig = ''
          # rescan when files are added (e.g. nicotine downloads)
          auto_update "yes"

          audio_output {
            type "pipewire"
            name "PipeWire"
          }
        '';
      };
      mpd-mpris = {
        enable = true;
      };
    };
  };
}
