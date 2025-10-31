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
    home-manager.enable = lib.mkEnableOption "home-manager";
    # home-manager.homes = lib.mkOption {
    #   type = lib.types.listOf lib.types.str;
    #   default = [];
    #   description = "extra homes from /homes to set up";
    # };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.home-manager.enable
      {
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          extraSpecialArgs = {inherit inputs;};
          backupFileExtension = "hm-bup";
          # overwriteBackup = true; # TODO: set to true on next home manager
          sharedModules = [
            inputs.self.homeManagerModules.default
            {
              # Ensure that HM uses the same Nix package as NixOS.
              nix.package = lib.mkForce config.nix.package;
            }
          ];
          users = let
            enabledUsers = builtins.attrNames (lib.filterAttrs (_: user: user.enable) cfg.users);
            homesOfEnabledUsers = lib.intersectLists (mylib.fs.getDirs "${inputs.self}/homes") enabledUsers;
            homes =
              # cfg.home-manager.homes ++
              homesOfEnabledUsers;
          in
            lib.genAttrs homes (user: import "${inputs.self}/homes/${user}");
        };
      })
  ];
}
