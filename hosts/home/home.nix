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
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-gpu-nvidia-nonprime
      common-pc
      common-pc-ssd
    ]);

 hardware.nvidia.open = true;

  my.profiles = {
    workstation.enable = true;
    development.enable = true;
#   gaming.enable = true;
  };

  my.users.users.lost.enable = true;

  services.syncthing = {
    enable=true;
    user = "lost";
    dataDir = "/home/lost/Documents"; # Default folder for new synced folders
    configDir = "/home/lost/.config/syncthing"; # Folder for Syncthing's settings and keys
  };

  services.xserver.videoDrivers = ["nvidia"];

  system.stateVersion = "24.11";
}
