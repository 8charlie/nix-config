{pkgs, ...}: {
  system.primaryUser = "charlie";

  programs.fish.enable = true;

  # register the nix fish in /etc/shells so it is a permissible login shell
  # (the stock macOS shells are added automatically)
  environment.shells = [pkgs.fish];

  # charlie is a macOS-created account; listing it in knownUsers lets nix-darwin
  # assert its UserShell via dscl on every activation. uid/gid must match the
  # existing account (501/staff) or activation refuses to touch it.
  users.knownUsers = ["charlie"];
  users.users.charlie = {
    home = "/Users/charlie";
    uid = 501;
    gid = 20;
    shell = pkgs.fish;
  };
}
