{
  inputs,
  pkgs,
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

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.virtualbox.host.enable = true;
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [
    virt-viewer
  ];

  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "lost";
  };

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
    usershares.enable = true;
    settings = {
      global = {
        "usershare owner only" = false;
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
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

  # boot.kernelPackages = pkgs.linuxPackages_lqx;

  networking.interfaces.enp6s0 = {
    wakeOnLan = {
      enable = true;
    };
  };
  boot.kernelPatches = [
    {
      name = "wake on lan";
      patch = ./alx-wol_v6.12.patch;
      # https://github.com/AndiWeiss/alx-wol/blob/master/patches/alx-wol_v6.12.patch
      # :%s@v6\.12[^/]*/alx/@drivers/net/ethernet/atheros/alx/@g
      # :g/^diff -u/d
      # :%s@^--- @--- a/@
      # :%s@^+++ @+++ a/@
    }
  ];

  musnix.soundcardPciId = "00:1f.3";
  services.pipewire.wireplumber.extraConfig.micVolume = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "alsa_input.usb-Solid_State_System_Co._Ltd._LCS_USB_Audio_000000000000-00.mono-fallback";
          }
        ];

        actions = {
          update-props = {
            "audio.volume" = 1.35;
          };
        };
      }
    ];
  };

  system.stateVersion = "24.11";
}
