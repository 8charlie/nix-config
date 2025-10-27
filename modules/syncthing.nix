{ pkgs, ... }: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
      devices = {
        "Pixel 8 Pro" = {
          id =
            "PZGEDNX-MYSZIMS-O6UJG2U-TSD4D6B-CG4KX2Q-GVVF26C-NI75CBE-GL4V3QV";
        };
      };
      folders = {
        "vault" = {
          path = "/home/charlie/Documents/vault";
          devices = [ "Pixel 8 Pro" ];
        };
        "work" = {
          path = "/home/charlie/Documents/work";
          devices = [ "Pixel 8 Pro" ];
        };
      };
    };
  };
}
