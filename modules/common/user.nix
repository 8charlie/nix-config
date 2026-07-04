{pkgs, ...}: {
  users.users.charlie = {
    isNormalUser = true;
    description = "charlie";
    extraGroups = ["networkmanager" "wheel"];
  };
  #shell = pkgs.fish;
}
