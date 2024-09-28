{
  inputs,
  lib,
  mylib,
  config,
  ...
}: let
  cfg = config.my.users;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  options.my.users = {
    enable = lib.mkEnableOption "the user config";

    users.lost.enable = lib.mkEnableOption "the lost user";

    home-manager.enable = lib.mkEnableOption "home-manager";
    home-manager.homes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "extra homes from /homes to set up";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable
      {
        # programs.zsh.enable = true;
        # users.defaultUserShell = pkgs.zsh;
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
    (lib.mkIf cfg.home-manager.enable
      {
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          extraSpecialArgs = {inherit inputs;};
          sharedModules = [
            {
              # Ensure that HM uses t he same Nix package as NixOS.
              nix.package = lib.mkForce config.nix.package;

              # Allow HM to manage itself when in standalone mode.
              # This makes the home-manager command available to users.
              programs.home-manager.enable = true;

              # Try to save some space by not installing variants of the home-manager
              # manual, which I don't use at all. Unlike what the name implies, this
              # section is for home-manager related manpages only, and does not affect
              # whether or not manpages of actual packages will be installed.
              manual = {
                manpages.enable = false;
                html.enable = false;
                json.enable = false;
              };
            }
          ];
          users = let
            enabledUsers = builtins.attrNames (lib.filterAttrs (_: user: user.enable) cfg.users);
            homesOfEnabledUsers = lib.intersectLists (mylib.fs.getDirs "${inputs.self}/homes") enabledUsers;
            homes = cfg.home-manager.homes ++ homesOfEnabledUsers;
          in
            lib.genAttrs homes (user: import "${inputs.self}/homes/${user}");
        };
      })
  ];
}
