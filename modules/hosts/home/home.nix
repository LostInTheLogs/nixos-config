{
  inputs,
  den,
  ...
}: {
  den.aspects.home = {
    includes = [
      den.aspects.common
      den.aspects.profiles._
      den.aspects.kitty
      den.aspects.zsh
    ];

    nixos = {pkgs, ...}: {
      imports =
        [
          ./_hardware-configuration.nix
          ./_nvidia.nix
        ]
        ++ (with inputs.nixos-hardware.nixosModules; [
          common-cpu-intel
          common-gpu-nvidia-nonprime
          common-pc
          common-pc-ssd
        ]);

      networking.firewall.trustedInterfaces = ["enp6s0"];

      virtualisation.libvirtd.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;
      virtualisation.virtualbox.host.enable = true;
      programs.virt-manager.enable = true;
      environment.systemPackages = with pkgs; [
        virt-viewer
      ];

      services.displayManager = {
        autoLogin.enable = true;
        autoLogin.user = "vodfsh";
      };

      programs.kdeconnect.enable = true;

      services.syncthing = {
        openDefaultPorts = true;
        enable = true;
        user = "vodfsh";
        dataDir = "/home/vodfsh/Documents"; # Default folder for new synced folders
        configDir = "/home/vodfsh/.config/syncthing"; # Folder for Syncthing's settings and keys
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

      zramSwap = {
        enable = true;
        memoryPercent = 20;
      };

      musnix.soundcardPciId = "00:1f.3";
      # musnix.kernel.realtime = true;
      # musnix.kernel.packages = pkgs.linuxPackages_latest;

      services.pipewire.wireplumber.extraConfig."99-perms" = {
        "access.rules" = [
          {
            matches = [
              {"application.process.binary" = "electron";}
            ];
            actions = {
              update-props = {
                "default_permissions" = "rx";
              };
            };
          }
        ];
      };

      services.pipewire.wireplumber.extraConfig."99-micVolume" = {
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

      system.stateVersion = "24.11";
    };

    # host provides default home environment for its users
    # provides.to-users.homeManager = {pkgs, ...}: {
    #   home.packages = [pkgs.vim];
    # };
  };
}
