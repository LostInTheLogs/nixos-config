{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ./gpu.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-amd
      common-cpu-amd-pstate
      common-cpu-amd-zenpower
      common-pc-laptop
      common-pc-laptop-ssd
    ]);

  environment.systemPackages = with pkgs; [lenovo-legion inputs.legion-keyboard];
  environment.shellAliases = {
    turn-off-keyboard = "${inputs.legion-keyboard}/bin/legion-kb-rgb set --effect Static -c 0,0,0,0,0,0,0,0,0,0,0,0";
  };

  my.profiles = {
    workstation.enable = true;
    development.enable = true;
    gaming.enable = true;
    laptop.enable = true;
  };

  my.users.users.lost.enable = true;

  boot.kernelPackages = pkgs.unstable.linuxPackages_6_10; # 6.11 breaks nvidia

  time.hardwareClockInLocalTime = true; #  dual boot :/

  system.stateVersion = "24.05";
}
