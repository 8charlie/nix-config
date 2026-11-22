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
        # Fresh googlevideo URLs answer 403 for the first ~4s, and mpv gives
        # up on the first one; let ffmpeg retry (0s, 1s, 3s, ...) instead.
        stream-lavf-o-append = "reconnect_on_http_error=403";
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
