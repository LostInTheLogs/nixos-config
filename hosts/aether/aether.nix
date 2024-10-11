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

  services.tlp.settings = {
    # Run `tlp fullcharge` to temporarily
    # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
    START_CHARGE_THRESH_BAT0 = 0; # dummy value
    STOP_CHARGE_THRESH_BAT0 = 1; # conservation mode on, legions don't support custom thresholds
  };

  boot.kernelPackages = pkgs.unstable.linuxPackages_xanmod_latest;
#  hardware.nvidia.package = pkgs.unstable.linuxPackages_xanmod_stable.nvidiaPackages.stable;

  system.stateVersion = "24.05";
}
