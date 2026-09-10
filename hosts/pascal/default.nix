{lib, ...}: {
  imports = [
    ./graphics.nix
    ./hardware.nix
    ../../profiles/nixos/workstation.nix
    ../../modules/nixos/desktop/niri.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/i3.nix
    ../../modules/nixos/desktop/dms-greeter.nix
    ../../modules/nixos/gaming.nix
  ];

  networking.hostName = "pascal";
  nixpkgs.hostPlatform = "x86_64-linux";

  # disable the UHD 630 iGPU (no BIOS option for it); keeps it out of Vulkan
  boot = {
    blacklistedKernelModules = ["i915" "tpm_tis" "tpm_crb"];
    kernelParams = [
      "module_blacklist=i915"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "pcie_aspm.policy=performance"
    ];
    initrd.systemd.emergencyAccess = true;
  };
  # for faster boot
  systemd.services.systemd-tpm2-setup.enable = false;
  systemd.services.systemd-tpm2-setup-early.enable = false;

  # The Windows reserved partition advertises the same filesystem UUID as root.
  # Use root's unique partition UUID so boot always selects the correct device.
  fileSystems."/".device = lib.mkForce "/dev/disk/by-partuuid/19f7fe31-dd12-46f5-a151-55a07237ab58";

  system.stateVersion = "25.11";
}
