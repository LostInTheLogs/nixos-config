{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.my.users;
in {
  options.my.users = {
    enable = lib.mkEnableOption "the user config";

    users.lost.enable = lib.mkEnableOption "the lost user";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable
      {
        programs.zsh.enable = true;
        users.defaultUserShell = pkgs.zsh;
      })
    (lib.mkIf cfg.users.lost.enable
      {
        users.users.lost = {
          isNormalUser = true;
          createHome = true;
          home = "/home/lost";
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
            "docker"
            "podman"
            "git"
            "libvirtd"
          ];
        };
      })
  ];
}
