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

  # alx-wol patch todo
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_8;
  # boot.kernelPatches ={
  #   name = "rt";
  #   patch = fetchurl {
  #     url = "mirror://kernel/linux/kernel/projects/rt/${branch}/older/patch-${version}.patch.xz";
  #     sha256 = "12c2qpifcgij7hilhd7xrnqaz04gqf41m93pmlm8cv4nxz58cy36";
  #   };
  # } ;

  my.profiles = {
    workstation.enable = true;
    development.enable = true;
    gaming.enable = true;
    music.enable = true;
  };

  # environment.systemPackages = with pkgs; [];

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

  boot.kernelPackages = pkgs.linuxPackages_lqx;
  musnix.soundcardPciId = "00:1f.3";

  system.stateVersion = "24.11";
}
