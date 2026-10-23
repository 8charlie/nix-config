{
  home-manager.users.charlie = {config, ...}: {
    programs.beets = {
      enable = true;
      mpdIntegration.enableUpdate = true;
      settings = {
        directory = "~/Music";
        import = {
          copy = false; # tag files in place
          move = false;
          write = true;
          incremental = true; # skip already-imported folders next time
          incremental_skip_later = true;
          quiet_fallback = "skip";
          log = "~/.config/beets/import.log";
        };
        plugins = ["musicbrainz"];
      };
    };
  };
}
