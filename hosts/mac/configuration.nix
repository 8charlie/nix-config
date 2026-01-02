{pkgs, ...}: {
  nix.settings.experimental-features = "nix-command flakes";

  imports = [../../modules/common/packages.nix ../../modules/common/neovim.nix ../../modules/mac/packages.nix ../../modules/mac/homebrew.nix];
  nixpkgs.config.allowUnfree = true;
  system.primaryUser = "charlie";
  system.defaults = {
    # Reduce window resize animation duration.
    NSGlobalDomain.NSWindowResizeTime = 0.001;

    # Reduce motion.
    CustomSystemPreferences."com.apple.Accessibility".ReduceMotionEnabled = 1;
    universalaccess.reduceMotion = true;
  };
}
