{inputs, ...}: {
  imports = [inputs.dms.nixosModules.dank-material-shell];

  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = false;
  };
}
