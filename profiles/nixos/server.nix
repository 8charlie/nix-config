{pkgs, ...}: {
  imports = [./base.nix];

  environment.systemPackages = [pkgs.vim];
  documentation.man.cache.enable = false;
}
