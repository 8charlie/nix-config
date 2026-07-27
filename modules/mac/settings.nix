{
  # per-machine bits for the M5 go here (casks, defaults, hardware-ish tweaks)
  system.defaults.dock = {
    autohide = true;
    show-recents = false;
    mru-spaces = false;
    tilesize = 48;
    magnification = false;
    showhidden = true;
    mouse-over-hilite-stack = true;

    # zero out animations
    autohide-delay = 0.0;
    autohide-time-modifier = 0.0;
    expose-animation-duration = 0.0;
    launchanim = false;

    # disable hot corners (1 = "no action")
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
  };
  # KEYBOARD / GLOBAL
  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 15; # lower = shorter delay before repeat
    KeyRepeat = 2; # lower = faster repeat
    ApplePressAndHoldEnabled = false; # repeat key instead of accent popup
    AppleShowAllExtensions = true;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
    NSDocumentSaveNewDocumentsToCloud = false;
    AppleShowScrollBars = "WhenScrolling";
  };
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    ShowPathbar = true;
    FXPreferredViewStyle = "Nlsv"; # list view
    _FXShowPosixPathInTitle = true;
    FXEnableExtensionChangeWarning = false;
  };

  system.defaults.menuExtraClock.Show24Hour = true;
  system.defaults.screencapture.location = "~/Downloads";
  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadThreeFingerDrag = true;

  # ================== UNSHITTIFY (from ncc's darwin-unshittify) ==================
  system.defaults.loginwindow.GuestEnabled = false;

  # require password immediately after sleep / screensaver
  system.defaults.screensaver.askForPassword = true;
  system.defaults.screensaver.askForPasswordDelay = 0;

  system.defaults.LaunchServices.LSQuarantine = false; # no "are you sure you want to open" nag
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

  # personalized ads off (no native option → raw preferences-domain write)
  system.defaults.CustomUserPreferences."com.apple.AdLib" = {
    allowApplePersonalizedAdvertising = false;
  };
}
