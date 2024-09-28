{
  inputs,
  pkgs,
  lib,
  ...
}: {
  my.profiles.testVm.enable = true;
  my.profiles.workstation.enable = true;
  # users.users.lost = {
  #   isNormalUser = true;
  #   extraGroups = ["wheel"];
  #   initialPassword = "testVm";
  #   shell = pkgs.zsh;
  # };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "24.05";
}
