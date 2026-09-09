{
  den,
  lib,
  ...
}: {
  den.aspects.vodfsh = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.batteries.host-aspects
      (den.batteries.user-shell "zsh")
    ];

    homeManager = {
      pkgs,
      osConfig,
      ...
    }: {
      home = {
        sessionPath = ["$HOME/.local/bin"];
      };

      xdg.configFile."nixpkgs/config.nix".text = ''
        {
          allowUnfree = true;
        }
      '';

      home.stateVersion = lib.mkDefault osConfig.system.stateVersion;
    };

    provides.to-hosts.nixos = {
      users.users.vodfsh = {
        initialPassword = "changemeimmediately";
        extraGroups = [
          "wheel"
          "systemd-journal"
          "audio"
          "video"
          "input"
          "plugdev"
          "lp"
          "tss"
          "power"
          "nix"
          "network"
          "networkmanager"
          "wireshark"
          "mysql"
          "podman"
          "git"
          "libvirtd"
          "vboxusers"
          "samba"
        ];
      };
    };
  };
}
