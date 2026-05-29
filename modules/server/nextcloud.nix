{
  config,
  pkgs,
  ...
}: let
  fqdn = "laptop.tail????.ts.net";
  port = 8080;
in {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = fqdn;

    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "16G";

    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = "/etc/nextcloud-admin-pass";
    };

    settings = {
      overwriteprotocol = "https";
      overwritehost = fqdn;
      "overwrite.cli.url" = "https://${fqdn}";
      trusted_proxies = ["127.0.0.1" " ::1"];
      default_phone_region = "GB";
    };
  };

  services.nginx.virtualHosts.${fqdn}.listen = [
    {
      addr = "127.0.0.1";
      port = port;
    }
  ];

  services.tailscale.enable = true;

  systemd.services.tailscale-serve-nextcloud = {
    description = "Serve Nextcloud over Tailscale HTTPS";
    after = ["tailscaled.service" "nginx.service"];
    wants = ["tailscaled.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https=443 http://127.0.0.1:${toString port}";
      ExecStop = "${pkgs.tailscale}/bin/tailscale serve --https=443 off";
    };
  };
}
