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
      ./nvidia.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-gpu-nvidia-nonprime
      common-pc
      common-pc-ssd
    ]);

  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "lost";
  };
  networking.interfaces.enp6s0 = {
    wakeOnLan = {
      enable = true;
    };
  };

  my.profiles = {
    workstation.enable = true;
    development.enable = true;
    gaming.enable = true;
    music.enable = true;
  };

  environment.systemPackages = with pkgs; [protonvpn-gui];

  my.users.users.lost.enable = true;

  hardware.nvidia-container-toolkit.enable = true;

  services.syncthing = {
    enable = true;
    user = "lost";
    dataDir = "/home/lost/Documents"; # Default folder for new synced folders
    configDir = "/home/lost/.config/syncthing"; # Folder for Syncthing's settings and keys
  };

  services.samba = {
    enable = true;
    package = pkgs.sambaFull;
    openFirewall = true;
    # usershares.enable = true; TODO: add on next release
  };

  zramSwap.enable = true;

  # nix copy --to file:///mnt/SSD/nixcache <nix store path>
  nix = {
    settings = {
      substituters = [
        "file:///mnt/SSD/nixcache"
      ];
      trusted-public-keys = [
      ];
    };
  };

  system.stateVersion = "24.11";
}
