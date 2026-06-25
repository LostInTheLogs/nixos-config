{
  inputs,
  den,
  ...
}: {
  flake-file.inputs = {
    legion-keyboard = {
      url = "github:4JX/L5P-Keyboard-RGB";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.aquarium = {
    includes = [
      den.aspects.common
      den.aspects.profiles._
      den.aspects.kitty
      den.aspects.zsh
    ];

    nixos = {
      pkgs,
      config,
      ...
    }: {
      imports =
        [
          ./_hardware-configuration.nix
          ./_gpu.nix
          ./_kanata.nix
        ]
        ++ (with inputs.nixos-hardware.nixosModules; [
          common-cpu-amd
          common-cpu-amd-pstate
          common-cpu-amd-zenpower
          common-pc-laptop
          common-pc-laptop-ssd
        ]);

      # uni
      virtualisation.libvirtd.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;
      programs.virt-manager.enable = true;

      environment.systemPackages = with pkgs; [lenovo-legion];
      boot.extraModulePackages = with config.boot.kernelPackages; [lenovo-legion-module];
      environment.shellAliases = {
        turn-off-keyboard-rgb = "sudo ${inputs.legion-keyboard.packages.x86_64-linux.default}/bin/legion-kb-rgb set --effect Static -c 0,0,0,0,0,0,0,0,0,0,0,0";
      };
      systemd.services.turn-off-keyboard-rgb = {
        script = "${inputs.legion-keyboard.packages.x86_64-linux.default}/bin/legion-kb-rgb set --effect Static -c 0,0,0,0,0,0,0,0,0,0,0,0";
        wantedBy = ["multi-user.target"];
        serviceConfig = {Type = "oneshot";};
      };

      services.syncthing = {
        openDefaultPorts = true;
        enable = true;
        user = "vodfsh";
        dataDir = "/home/vodfsh/Documents"; # Default folder for new synced folders
        configDir = "/home/vodfsh/.config/syncthing"; # Folder for Syncthing's settings and keys
      };

      # boot.kernelPackages = pkgs.unstable.linuxPackages_6_12; # 6.11 breaks nvidia

      time.hardwareClockInLocalTime = true; #  dual booting windows :/

      # networking.networkmanager.wifi.powersave = false;

      system.stateVersion = "24.05";
    };

    # host provides default home environment for its users
    # provides.to-users.homeManager = {pkgs, ...}: {
    #   home.packages = [pkgs.vim];
    # };
  };
}
