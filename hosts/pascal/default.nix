{
  imports = [
    ./graphics.nix
    ./hardware.nix
  ];

  # disable the UHD 630 iGPU (no BIOS option for it); keeps it out of Vulkan
  boot = {
    blacklistedKernelModules = ["i915" "tpm_tis" "tpm_crb"];
    kernelParams = [
      "module_blacklist=i915"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "pcie_aspm.policy=performance"
    ];
  };
  # for faster boot
  systemd.services.systemd-tpm2-setup.enable = false;
  systemd.services.systemd-tpm2-setup-early.enable = false;
}
