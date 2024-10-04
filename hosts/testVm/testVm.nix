{lib, ...}: {
  my.profiles = {
    testVm.enable = true;
    workstation.enable = true;
    development.enable = true;
    gaming.enable = true;
    music.enable = true;
  };

  my.users.users.lost.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "24.05";
}
