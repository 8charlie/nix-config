{
  pkgs,
  lib,
  ...
}: let
  sharedBrowser = {
    enable = true;

    # home-manager takes a flat list here, not `nativeMessagingHosts.packages`
    nativeMessagingHosts = [pkgs.tridactyl-native];

    policies = {
      # bitwarden replaces the built-in password manager
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      # features arkenfox can only default off
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DontCheckDefaultBrowser = true;
      # extensions keyed by GUID; installed from AMO and auto-updated
      # by firefox itself
      ExtensionSettings =
        lib.mapAttrs' (slug: guid: {
          name = guid;
          value = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
            installation_mode = "force_installed";
          };
        }) {
          ublock-origin = "uBlock0@raymondhill.net";
          bitwarden-password-manager = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
          tridactyl-vim = "tridactyl.vim@cmcaine.co.uk";
          darkreader = "addon@darkreader.org";
          violentmonkey = "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}";
          raindropio = "jid0-adyhmvsP91nUO8pRv0Mn2VKeB84@jetpack";
        };
    };
  };
in {
  programs.firefox = sharedBrowser;

  programs.librewolf =
    sharedBrowser
    // {
      settings = {
        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.exemptedDomains" = "claude.ai";
      };
    };
}
