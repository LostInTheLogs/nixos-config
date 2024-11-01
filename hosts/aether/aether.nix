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
      ./kanata.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-amd
      common-cpu-amd-pstate
      common-cpu-amd-zenpower
      common-pc-laptop
      common-pc-laptop-ssd
    ]);

  environment.systemPackages = with pkgs; [lenovo-legion inputs.legion-keyboard.packages.x86_64-linux.default];
  environment.shellAliases = {
    turn-off-keyboard = "sudo ${inputs.legion-keyboard.packages.x86_64-linux.default}/bin/legion-kb-rgb set --effect Static -c 0,0,0,0,0,0,0,0,0,0,0,0";
  };
  systemd.services.turn-off-keyboard = {
    script = "${inputs.legion-keyboard.packages.x86_64-linux.default}/bin/legion-kb-rgb set --effect Static -c 0,0,0,0,0,0,0,0,0,0,0,0";
    wantedBy = ["multi-user.target"];
    serviceConfig = {Type = "oneshot";};
  };

  my.profiles = {
    workstation.enable = true;
    development.enable = true;
    gaming.enable = true;
    laptop.enable = true;
  };

  my.users.users.lost.enable = true;

  my.syncthing.enable = true;
  services.syncthing = {
    user = "lost";
    dataDir = "/home/lost/Documents"; # Default folder for new synced folders
    configDir = "/home/lost/.config/syncthing"; # Folder for Syncthing's settings and keys
  };

  boot.kernelPackages = pkgs.unstable.linuxPackages_6_10; # 6.11 breaks nvidia

  time.hardwareClockInLocalTime = true; #  dual booting windows :/

  networking.networkmanager.wifi.powersave = false;

  system.stateVersion = "24.05";
}
