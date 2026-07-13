{lib, ...}: {
  # symlink each directory in dots/ to ~/.config; applied at login by
  # systemd-tmpfiles-setup.service, or immediately via `systemd-tmpfiles --user --create`
  systemd.user.tmpfiles.users.charlie.rules =
    lib.mapAttrsToList
    (name: _: "L+ %h/.config/${name} - - - - %h/.dotfiles/dots/${name}")
    (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ../../dots));
}
