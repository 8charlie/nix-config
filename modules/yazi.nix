{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      open = {
        rules = [
          {
            mime = "text/*";
            use = "edit";
          }
          {
            mime = "video/*";
            use = "play";
          }
        ];
      };
    };
  };
}
