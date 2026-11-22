{pkgs, ...}: {
  # YouTube is watched in mpv (via tube, see ./tube.nix, or FreeTube's
  # external player button) since FreeTube's own player keeps reloading on
  # SABR requests.
  # mpv's nixpkgs wrapper already puts yt-dlp (with a JS runtime for
  # YouTube) on its PATH.
  home-manager.users.charlie = {
    home.packages = [pkgs.yt-dlp];

    programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        sponsorblock
        # modern OSC: chapter markers and titles on the timeline, chapter menu
        uosc
        # play/pause/seek from the DMS bar's media controls
        mpris
      ];

      config = {
        # uosc replaces the built-in OSC and OSD bar
        osc = "no";
        osd-bar = "no";
        # matches FreeTube's default quality; speed and start time are passed
        # by FreeTube itself
        ytdl-format = "bestvideo[height<=?1440]+bestaudio/best";
        save-position-on-quit = true;
        # ffmpeg options for googlevideo:
        # - reconnect_on_http_error: fresh URLs answer 403 for the first ~4s
        #   and mpv gives up on the first one; retry (0s, 1s, 3s, ...) instead
        # - request_size + multiple_requests: fetch in 10 MB ranges over one
        #   connection, like yt-dlp. A single open-ended request (ffmpeg's
        #   default) is throttled to ~1 Mbps, barely above playback speed,
        #   so mpv buffered only a few seconds ahead and kept stalling;
        #   ranges come at full speed (176 vs 1.1 Mbps when measured).
        stream-lavf-o = "reconnect_on_http_error=403,request_size=10485760,multiple_requests=1";
      };

      # FreeTube's default speed, for YouTube only (FreeTube's external player
      # button passes --speed itself, which still wins)
      profiles.youtube = {
        profile-cond = "path:find('youtube%.com/') or path:find('youtu%.be/')";
        profile-restore = "copy";
        speed = 1.5;
      };

      scriptOpts.sponsorblock = {
        # mirrors the SponsorBlock settings in FreeTube: everything is shown
        # as a chapter, only sponsor/selfpromo/interaction are auto-skipped
        categories = "sponsor,selfpromo,interaction,intro,outro,preview,filler,music_offtopic";
        skip_categories = "sponsor,selfpromo,interaction";
        make_chapters = "yes";
        report_views = "no";
      };

      bindings = {
        "c" = "script-binding uosc/chapters";
        "MBTN_RIGHT" = "script-binding uosc/menu";
      };
    };
  };
}
